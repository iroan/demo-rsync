set -x

cur=$PWD
src=./src
dst=./dst

# 删除旧文件，创建新文件夹，清理环境
rm -rf $src
rm -rf $dst

mkdir -p $src
mkdir -p $dst

function transLocal() {
    # 新增一个文件
    cd $src
    echo "wkx" >name.txt

    # 查看两个目录的内容
    tree $src
    tree $dst
    # 进行同步
    cd $cur
    rsync -a $src/ $dst

    # 再次查看两个目录的内容
    tree $src
    tree $dst
}

function daemon() {
    ls rsync*
    sudo rsync --daemon --config=./rsyncd.conf
}

function transRemote() {
    tree /home/iroan/tmp/remote
    startTime=$(date +%s)

    rsync -av \
        --password-file=./rsync.password \
        /mnt/wd40ezrz/multimedia/film/动作/ \
        rsync@localhost::test

    endTime=$(date +%s)
    ((intervalTime = $endTime - $startTime))
    echo "intervalTime:${intervalTime}"

    tree $dst
}

if [ "$1" == "daemon" ]; then
    daemon
elif [ "$1" == "transRemote" ]; then
    transRemote
elif [ "$1" == "transLocal" ]; then
    transLocal
fi
