

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
//	// ifstream ��ȡ�ļ� ofstream д�ļ�
//	ifstream in;
//
//	// �ļ���
//	string filename;
//
//	// ��ȡ�ļ���
//	getline(cin, filename, '\n');
//
//	// ��
//	in.open(filename);
//
//	if(!in){
//		cerr << "���ļ�����" << endl;
//		return 1;
//	}
//
//	// ���ַ���ȡ
//	char ch;
//	// ��δ���ļ���β
//	while(!in.eof()){
//		//��ȡ
//		in.read(&ch, 1);
//		cout << ch;
//	}
//
//	// Ҫ��ס�رմ򿪵��ļ�
//	in.close();
//	
//	return 0;
//}












