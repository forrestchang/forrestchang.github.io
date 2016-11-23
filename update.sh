cd ~/.emacs.d/.cache
rm -rf .org-timestamps
cd ~/blog/public
git add .
git commit -m 'auto update'
proxychains4 git push
