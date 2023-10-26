flutter build web --release

cp -R build/web/* website/

git add .
git commit -m "update website"