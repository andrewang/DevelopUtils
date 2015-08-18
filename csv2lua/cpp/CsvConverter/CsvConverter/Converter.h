

#pragma once

#include <string>
#include <vector>

using namespace std;

class Converter
{
public:
	Converter(void);
	~Converter(void);

	vector<string> readCsv(const string& filename);
	void writeIni(const string& filename, vector<string>);
};

