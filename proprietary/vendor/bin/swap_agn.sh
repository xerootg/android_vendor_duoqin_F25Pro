#! /vendor/bin/sh
# 定义swap文件及其预期大小映射
swap_files=( "/data/vendor/swap1.img" "/data/vendor/swap2.img" "/data/vendor/swap3.img" )
#3G 2G 3G
swap_sizes=( "3221225472" "2147483648" "3221225472" )
swap_counts=( "3072" "2048" "3072" )

echo "========== begin $1 ============="
start=$(date +%s)

manage_swap_file() {
    local file="${swap_files[$1]}"
    local expected_size=${swap_sizes[$1]}
    local file_size=$(stat -c '%s' $file)
    local count=${swap_counts[$1]}

    if [[ ! -f $file ]] || [[ $file_size -lt ${expected_size} ]]; then
        echo "not exist files or file_size error,recreate $file"
        rm -rf "$file"
        dd if=/dev/zero of="$file" bs=1M count=${count}
        mkswap "$file"
        swapon "$file"
    else
        echo "$file exist."
        mkswap "$file"
        swapon "$file"
    fi
}

remove_swap_file() {
    local file=$1
    if [ -f "$file" ]; then
        swapoff "$file"
        rm -rf "$file"
    fi
}

if [ -z "$1" ]; then
  remove_swap_file "${swap_files[0]}"
  remove_swap_file "${swap_files[1]}"
  remove_swap_file "${swap_files[2]}"
else	
  case $1 in
    "3G")
        manage_swap_file 0
        remove_swap_file "${swap_files[1]}"
        remove_swap_file "${swap_files[2]}"
        ;;
    "5G")
        manage_swap_file 0
        manage_swap_file 1
        remove_swap_file "${swap_files[2]}"
        ;;
    "8G")
        manage_swap_file 0
        manage_swap_file 1
        manage_swap_file 2
        ;;
  esac
fi

end=$(date +%s)
duration=$((end - start))
echo "======= end: $duration ========="
