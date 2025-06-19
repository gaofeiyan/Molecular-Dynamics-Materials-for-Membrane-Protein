#!/bin/bash

# 用法: ./make_chain_ndx.sh your.pdb

if [ $# -ne 1 ]; then
    echo "用法: $0 your_structure.pdb"
    exit 1
fi

pdbfile=$1

# 提取所有唯一的链ID
chains=$(grep '^ATOM' "$pdbfile" | cut -c22 | sort | uniq | grep -v ' ')

echo "检测到以下链: $chains"

# 为每个链生成 .ndx 文件
for chain in $chains; do
    echo "正在处理链 $chain ..."
    gmx select -s "$pdbfile" -select "chain $chain" -on "chain_$chain.ndx"
done

cat chain_*.ndx > chains_ABC.ndx

echo "所有链索引文件已生成完成。"

