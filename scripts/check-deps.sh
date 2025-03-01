#!/usr/bin/env bash
# Quick check for dependencies
set -u

version_gte() {
    [ "$2" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

errors=0

python_ver_req=3.9
python_ver_inst=$(python3 --version | awk '{print $2}')
if ! version_gte $python_ver_inst $python_ver_req; then
    errors=$((errors + 1))
    echo "Python version below $python_ver_req."
fi

doit_ver_req=0.34
doit_ver_inst=$(doit --version | head -n 1)
if ! version_gte $doit_ver_inst $doit_ver_req; then
    errors=$((errors + 1))
    echo "Doit version below $doit_ver_req."
fi

pandoc_ver_req=2.9
pandoc_ver_inst=$(pandoc --version | head -n 1 | awk '{print $2}')
if ! version_gte $pandoc_ver_req $pandoc_ver_req; then
    errors=$((errors + 1))
    echo "Pandoc version below $pandoc_ver_req."
fi

if ! pdflatex --version > /dev/null; then
    errors=$((errors + 1))
    echo "PDFLaTeX not installed."
fi


latex_packages_req="\
    environ etoolbox fancyhdr forest ly1 mathdesign mathtools \
    ntheorem standalone stix2-type1 tcolorbox tikz tipa"
latex_packages_inst=$(tlmgr list --only-installed | awk '{print $2}' | tr -d ':')
for pkgname in $latex_packages_req; do
    if ! echo $latex_packages_inst | grep -wq $pkgname; then
        errors=$((errors + 1))
        echo "LaTeX package '$pkgname' not installed."
    fi
done

if [ $errors -gt 0 ]; then
    echo "Some dependencies unmet."
else
    echo "All dependencies met."
fi
