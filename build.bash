# Build the ebook. Check build.md to prep build environment.

# Check arg.
case $1 in
    epub) echo "Building $1" ;;
    pdf) echo "Building $1" ;;
    *) echo "Usage: $0 [epub|pdf]" > /dev/stderr && exit 1
esac

# Pre-process foreward template version.
if [[ -n $(git status -s) ]]; then
    COMMIT="#######"
    EPOCH=$(date +%s)
else
    COMMIT=$(git log -1 --format=%h)
    EPOCH=$(git log -1 --format=%ct)
    TAG=$(git describe --tags --candidates=0 $COMMIT 2>/dev/null)
    if [[ -n $TAG ]]; then
        COMMIT=$TAG
    fi
fi
DATE="@$EPOCH"
VERSION="Commit $COMMIT, $(date -d $DATE +'%B %d, %Y')."
sed "s/{{ version }}/$VERSION/g" foreward.tpl.md > foreward.md
echo "${VERSION}"

# Pre-process input files.
MD="GuodianLaozi-$COMMIT.md"
sed -s '$G' -s \
    foreward.md \
    a-01-r19.md \
    a-02-r66.md \
    a-03-r46b.md \
    a-04-r30.md \
    a-05-r15.md \
    a-06-r64b.md \
    a-07-r37.md \
    a-08-r63.md \
    a-09-r2.md \
    a-10-r32a.md \
    a-11-r32b.md \
    a-12-r25.md \
    a-13-r5b.md \
    a-14-r16a.md \
    a-15-r64a.md \
    a-16-r56.md \
    a-17-r57.md \
    a-18-r55.md \
    a-19-r44.md \
    a-20-r40.md \
    a-21-r9.md \
    b-01-r59.md \
    b-02-r48a.md \
    b-03-r20a.md \
    b-04-r13.md \
    b-05-r41.md \
    b-06-r52b.md \
    b-07-r45a.md \
    b-08-r45b.md \
    b-09-r54.md \
    c1-01-r17r18.md \
    c1-02-r35.md \
    c1-03-r31.md \
    c1-04-r64b.md \
    c2-01-t1-8a.md \
    c2-02-t1-8b.md \
    c2-03-t1-8c.md \
    c2-04-t9.md \
    c2-05-t10-14.md \
    README.md \
    notes.md > "$MD"

# Build epub.
if [ $1 = "epub" ]; then
    EPUB="GuodianLaozi-$COMMIT.epub"
    HTML="GuodianLaozi-$COMMIT.html.md"
    CJK_FONT="/usr/share/fonts/opentype/noto/NotoSerifCJK-Light.ttc"
    CJK_OUT="epub-fonts/CJK.ttf"
    python epub_fonts.py "$MD" "$CJK_FONT" "$CJK_OUT" cjk
    bash epub-html.bash "$MD" > "$HTML"
    pandoc "$HTML" \
        --defaults epub-defaults.yaml \
        --output "${EPUB}"
    echo Built "${EPUB}"
fi

## Or build pdf.
if [ $1 = "pdf" ]; then
    PDF="GuodianLaozi-$COMMIT.pdf"
    TEX="GuodianLaozi-$COMMIT.tex.md"
    bash pdf-latex.bash "$MD" > "$TEX"
    pandoc "$TEX" \
        --defaults pdf-defaults.yaml \
        --output "${PDF}"
    echo Built "${PDF}"
fi
