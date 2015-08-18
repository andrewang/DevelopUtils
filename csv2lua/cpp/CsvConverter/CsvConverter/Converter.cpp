

#include "Converter.h"
#include <fstream>
#include <iostream>
#include <codecvt>

Converter::Converter(void){}

Converter::~Converter(void){}

vector<string> Converter::readCsv(const string& filename)
{
	vector<string> lines;

	ifstream fileReader;
	fileReader.open(filename);

	if (!fileReader.is_open())
	{
		cout << "can not open then file:" << filename << endl;
		return lines;
	}
	
	
	string line;
	while (getline(fileReader, line))
	{
		// ×ª»»±àÂë¸ñÊ½
		wstring_convert<codecvt_utf8<codecvt_base>> convert;
		convert
		line = convert.(line.c_str());

		lines.push_back(line);
	}

	return lines;
}

void Converter::writeIni(const string& filename, vector<string> lines)
{
	ofstream fileWriter(filename);

	if (!fileWriter.is_open())
	{
		cout << "can not open the file:" << filename << endl;
		return;
	}
	
		for (auto line : lines)
	{
		fileWriter << line << endl;
	}

	fileWriter.close();
}














