# cd ~/.emacs.d/.cache
# rm -rf .org-timestamps
cd ~/Documents/Blog
echo 'forrestchang.com' > CNAME
git add .
git commit -m 'auto update'
proxychains4 git push
