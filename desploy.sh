#!/usr/bin/env sh

# 忽略错误
set -e

# 构建
yarn build

# 复制 github actions
mkdir -p dist/.github/workflows
cp  github-workflows-web-static.yml dist/.github/workflows/web-static.yml

# 进入待发布的目录
cd dist

# 如果是发布到自定义域名
echo 'today.g-bill.club' > CNAME

git init
git remote add origin git@github.com:go-bineanshi/web-bind-wrapper.git

git add -A
git commit -m 'deploy' 

git push -f origin main

# 回到之前的目录
cd -

# 删除 dist
rm -rf dist