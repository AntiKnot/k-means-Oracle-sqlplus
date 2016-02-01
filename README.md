##说明

代码运行环境为windows-Oracle。

因为也将随机数据生成和建表也写进了脚本中，又没有加建表判断，所以只能运行一次。此源代码的价值更多是了解算法的实现过程。

0.plsql中会出现大量乱码干扰程序，删除注释 注释集中在文件k_means_read.txt中
1.将文件夹k_means粘贴至c盘根目录或者指定的地址
2.打开cmd->输入sqlplus
3.执行下列命令
conn /as sysdba
口令直接回车
alter user user309 identified by 123;
grant dba to user309;
conn user309/123;
@[路径]\k_means\k_means_handle.pdc
k的范围为2~数据量
输入1 测试最小范围
输入100 测试最大范围 （数据量为随机生成的50）
输入k值 测试k_means算法正确性
4.查看运行结果
select * from t_result order by k_class;

输出结果
输出
数值：【空】
'begin handle' --代表一次迭代
数值：类别
'begin handle' --代表再次迭代
数值: 类别
select..后
在表中输出最终结果

bug：由于被处理数据为随机产生 人为insert不会产生此类bug
1.在随机生成的data数值中存在相同数值
在乱序取随机k值时候有很小几率出现k值相等（待解决）
2.小几率出现除数为零的状况。
3.在执行@时候存在一个乱码无法清除 被系统跳过不影响算法运行

缺陷：
pdc文件的流程
创建数据表->创建结果表->随机注入50个数据->创建中心点表->运算
程序的打包运行只用于展示不利于重复运行
运算数据被insert入结果表中不能重复使用






