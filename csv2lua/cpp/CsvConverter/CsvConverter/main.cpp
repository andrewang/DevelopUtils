

#include <iostream>
#include "Converter.h"

using namespace std;

int main(){

	Converter converter;

	auto lines = converter.readCsv("visitor_res.csv");
	converter.writeIni("test.ini", lines);

	cout << "---done---" << endl;

	return 0;
}


















//#include <fstream>
//#include <string>
//
//using namespace std;
//
//int main()
//{
//	// ifstream 读取文件 ofstream 写文件
//	ifstream in;
//
//	// 文件名
//	string filename;
//
//	// 获取文件名
//	getline(cin, filename, '\n');
//
//	// 打开
//	in.open(filename);
//
//	if(!in){
//		cerr << "打开文件出错！" << endl;
//		return 1;
//	}
//
//	// 逐字符读取
//	char ch;
//	// 当未到文件结尾
//	while(!in.eof()){
//		//读取
//		in.read(&ch, 1);
//		cout << ch;
//	}
//
//	// 要记住关闭打开的文件
//	in.close();
//	
//	return 0;
//}












