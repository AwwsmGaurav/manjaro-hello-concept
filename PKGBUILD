pkgname=manjaro-hello-concept
pkgver=0.3.0
pkgrel=1
pkgdesc="A modern Qt6/QML UI/UX concept redesign for Manjaro Hello"
arch=('any')
url="https://github.com/AwwsmGaurav/manjaro-hello-concept"
license=('MIT')
depends=('python' 'pyside6' 'noto-fonts')
source=()

package() {
    install -dm755 "$pkgdir/usr/share/$pkgname"
    cp -r "$startdir/main.py" "$startdir/ui" "$startdir/data" "$startdir/assets" "$pkgdir/usr/share/$pkgname/"

    install -dm755 "$pkgdir/usr/bin"
    cat << 'EOF' > "$pkgdir/usr/bin/$pkgname"
#!/bin/sh
exec python /usr/share/manjaro-hello-concept/main.py "$@"
EOF
    chmod 755 "$pkgdir/usr/bin/$pkgname"
}