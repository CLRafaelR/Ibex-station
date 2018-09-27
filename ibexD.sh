#!/bin/bash

#resultsフォルダ内のraw_resultをtxtファイルとして現在のディレクトリにコピー
#今回は、結果ファイルにテストランの結果も入っているため、手動でコピーし、
#コピーしたファイルの中でテストランの結果を除去
#cp results/raw_results output1.txt

#output1.txtをさらにコピーし安全を期す
cp output1.txt output1-2.txt

#output1-2.txtを直接編集
#トライアルを区切る++は、新しい行に変換
#トライアルの要素を区切る==は、タブに変換
#	-iはファイルの直接編集（--in-place）
#-e[半角空白]'スクリプト'で、コマンドを追加
#「s/置換前/置換後/g」で、文字列を置換
#ここでは、オリジナルの通りに「sed -i '' 」とすると
#sed: can't read : No such file or directory
#というエラーが出る
#''は「-i'.BackupFilename'」のように用いる
#今回はバックアップファイルを特に作成しないため、
#このファイルでは''は付けないこととする
sed -i -e  's/+ + + //g'  output1-2.txt
sed -i -e  's/\]\],\[\[/\]++\[/g'  output1-2.txt
sed -i -e  's/\],\[/\]==\[/g'  output1-2.txt

tr '++' '
' < output1-2.txt > output1-3.txt

#先頭列に、実験のIDを付ける
#output1_aの箇所は、自分の実験名であれば任意の名前を付けてよい
#ここも、オリジナルの通りに「sed -i '' 」とすると
#sed: can't read : No such file or directory
#のエラーが出る
sed -i -e 's/^/output1_a==/' output1-3.txt

tr '==' '\t' < output1-3.txt > output1-X.txt

#中間生成ファイルの消去
rm output1-2.txt
rm output1-3.txt

#実験の数だけ生成される*X.txtを1つのファイルに結合
cat *X.txt > output_data2.txt

#*X.txtファイル群を消去
rm *X.txt

#output1-X.txtに含まれる空白列の消去
#$記号の後にくる奇数の数字は、各自のデータに合わせて増やしたり減らしたり調整
awk -F'\t' '$3!="" {print $1,$3,$5,$7,$9,$11,$13,$15}' output_data2.txt > output_data4.txt

#[の前に+を付け、さらに+をタブに変換することでタブ区切りを施す
sed -i -e  's/\[/+\[/g'  output_data4.txt
tr '+' '\t' < output_data4.txt > output_data.txt

#中間生成ファイルの消去
rm output_data4.txt

#タブ区切りになったデータファイルをコピー
cp output_data.txt output_data_test.txt

#各セルに列番号が付いているので、それらを消去
sed -i -e  's/11,//g'  output_data_test.txt
sed -i -e  's/12,//g'  output_data_test.txt
sed -i -e  's/13,//g'  output_data_test.txt
sed -i -e  's/14,//g'  output_data_test.txt
sed -i -e  's/15,//g'  output_data_test.txt
sed -i -e  's/16,//g'  output_data_test.txt
sed -i -e  's/17,//g'  output_data_test.txt
sed -i -e  's/18,//g'  output_data_test.txt
sed -i -e  's/19,//g'  output_data_test.txt
sed -i -e  's/10,//g'  output_data_test.txt
sed -i -e  's/1,//g'  output_data_test.txt
sed -i -e  's/2,//g'  output_data_test.txt
sed -i -e  's/3,//g'  output_data_test.txt
sed -i -e  's/4,//g'  output_data_test.txt
sed -i -e  's/5,//g'  output_data_test.txt
sed -i -e  's/6,//g'  output_data_test.txt
sed -i -e  's/7,//g'  output_data_test.txt
sed -i -e  's/8,//g'  output_data_test.txt
sed -i -e  's/9,//g'  output_data_test.txt
sed -i -e  's/0,//g'  output_data_test.txt
sed -i -e  's/" /"/g'  output_data_test.txt
sed -i -e  's/"//g'  output_data_test.txt

#IbexのFormを使った実験の場合
#以下のスクリプトでデータを抽出

#オリジナルの
#awk -F'\t' '$4=="\[Form\]" {print $2,$3,$5,$9,$10}' output_data_test.txt > output_demog1.txt
#には、2つ誤りがあると思われる。
#まず、awk -F'\t' '$4=="\[ExpType\]"となっているが、
#$4は$2の間違いではないかと思われる。
#また、-F'\t'でタブ区切りで列が分割されていると明示的に指定すると、
#正しく書き出せない（列を探せなくなる）。
#原因はタブ2個で列を区切っているためか。
#そのため、フィールドを指定しない方がよい。
#なお、今回の実験では、FormではなくFormCountsを使用した
#Formを強化し、進捗状況表示バーを正しく画面に出せるFormCountsを使用

awk '$2=="\[FormCounts\]" {print $2,$3,$5,$6,$7,$8,$9}' output_data_test.txt > output_demog1.txt

#2個のタブを検出しようとしても、このようなコマンドは使えない
#awk -F'\t\t' '$2=="\[FormCounts\]" {print $2,$3,$5,$9,$10}' output_data_test.txt > output_demog1.txt

sed -i -e  's/\] \[/\]+\[/g'  output_demog1.txt
tr '+' '\t' < output_demog1.txt > output_demog2.txt

##なぜか$3=="\[target\]" || $3=="\[filler\]" || $3=="\[h1\]" || $3=="\[h2\]"の時に
##$5と$6が分割されているため、結合する
##awk -i inplace '{if($3=="\[target\]" || $3=="\[filler\]" || $3=="\[h1\]" || $3=="\[h2\]") print $1,}' output_demog2.txt

#awk -i inplace 'BEGIN{OFS="\t"}{$6=$6 "\t" $6;print}' output_demog2.txt
#awk '{if($5=="\[subjnum\]") print $0 " " $6}' output_demog2.txt > output_demog2-2.txt

#参加者番号を先頭に付ける
#以下の行では、参加者番号を回答に含む行でのみ、参加者番号が先頭に付与される
#それ以外の行はそのまま出力される
awk 'BEGIN{OFS="\t"} {if($5=="\[subjnum\]") print $6,$0; else print $0}' output_demog2.txt > output_demog2-1.txt

#awk 'a[NR]=$1 {if($5=="\[subjnum\]") print $6, $0; else print a[NR-1], $0}' output_demog2.txt > output_demog2-4.txt
#awk '{print $1}' output_demog2-5.txt
#awk 'a[NR]=$1 {$1=="\["[0-9]"\]" print $1; else print a[NR-1]}' output_demog2-3.txt
#awk '{if($1 ~ /^\[[0-9]\]$/) print $0}' output_demog2-3.txt
#awk '$1 ~ /^\[[0-9]\]$/ {line = line + 1; print line $0}' output_demog2-3.txt
#awk '$1 ~ /^\[[0-9]\]$/ {num = $1; print num, $0}' output_demog2-3.txt

#先頭フィールド$1が参加者番号で始まっている場合に、その$1をnumという変数に格納
#先頭フィールド$1が参加者番号で始まっている場合は、その行をそのまま出力
#そうでない場合、numと計算中の行自身を出力
awk 'BEGIN{OFS="\t"} $1 ~ /^\[[0-9]\]$/ {num = $1} {if($1 ~ /^\[[0-9]\]$/) print $0; else print num, $0}' output_demog2-1.txt > output_demog2-2.txt

#awk 'a[NR]=$1 {if($5!="\[subjnum\]") print a[NR-1], $0; else print $0}' output_demog2-5.txt > output_demog2-6.txt

#awk 'a[NR]=$6;b[NR]=$7 {if($5=="\[subjnum\]") print $0 a[NR]; else print $0 b[NR-1]}' output_demog2.txt > output_demog2-5.txt
#awk 'b[NR]=$7 {if($5=="\[subjnum\]") print $0; else print b[NR-1]}' output_demog2-4.txt > output_demog2-6.txt

#awk 'BEGIN{OFS="\t"} {if($4 !~ /^\[target\]$/ || $4 !~ /^\[h1\]$/ || $4 !~ /^\[h2\]$/) print $0}' output_demog2-2.txt > output_demog2-3.txt

#awk 'BEGIN{OFS="\t"} $4 ~ /(^\[target\] | ^\[h1\])/ {print $0}' output_demog2-2.txt > output_demog2-3.txt

#必要な実験条件の回答分のみ抽出
awk 'BEGIN{OFS="\t"} $4 ~ /^\[target\]$|^\[h1\]$|^\[h2\]$/ {print $0}' output_demog2-2.txt > output_demog2-3.txt


#[_REACTION_TIME_]のない行を出力することで、産出された文を抽出
#下記のコマンドも、オリジナルの$4を$5に変更
#[_REACTION_TIME_]は第5フィールドにあるため
awk -F'\t' '$6!="\[\_REACTION\_TIME\_\]" {print $0}' output_demog2-3.txt > output_demog3.txt

#[_REACTION_TIME_]のある行を出力することで、文産出にかかった時間を抽出
awk -F'\t' '$6=="\[\_REACTION\_TIME\_\]" {print $0}' output_demog2-3.txt > output_demog3-1.txt

#産出された文とその産出にかかった時間をひとつのファイルに結合
paste -d "\t" output_demog3.txt output_demog3-1.txt > output_demog3-2.txt

#結合したファイルから必要な情報だけを抽出
awk -F'\t' '{print $1,$3,$5,$6,$7,$14}' output_demog3-2.txt > output_demog3-3.txt

#括弧類を消去
#オリジナルの「sed -i '' -e」は「sed -i -e」に替える
sed -i -e 's/\] \[/+/g' output_demog3-3.txt
sed -i -e 's/\]//g' output_demog3-3.txt
sed -i -e 's/\[//g' output_demog3-3.txt
sed -i -e 's/,CtjwLyloJDPZOIJyNVgjZQ,true//g' output_demog3-3.txt
tr '+' '\t' < output_demog3-3.txt > output_demog.txt

#中間生成ファイルの消去
rm output_demog1.txt
rm output_demog2.txt
rm output_demog2-1.txt
rm output_demog2-2.txt
rm output_demog2-3.txt
rm output_demog3.txt
rm output_demog3-1.txt
rm output_demog3-3.txt
