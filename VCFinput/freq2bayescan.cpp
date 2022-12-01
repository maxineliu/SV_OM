// Usage: ./freq2bayescan <*.gp1.frq> <*.gp2.frq> ... <*.gpN.frq>
// robust to relative path or absolute path

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cmath>

using namespace std;

class Locus {
public:
	int index;
	string chrom;
	int POS;
	int nAllele;
	int nChrom;
	double allele1FREQ;
	double allele2FREQ;
	int allele1;
	int allele2;
};

//Overloads operator ">>" to make C++ understand how to read the object contents from a line
std::istream& operator>>(std::istream& is, Locus& locus){
	is >> locus.chrom >> locus.POS >> locus.nAllele >> locus.nChrom >> locus.allele1FREQ >> locus.allele2FREQ;
	return is;
};


//Overloads operator "<<" to make C++ understand how to print the object contents
std::ostream& operator<<(std::ostream& os, const Locus& locus) {
	os << locus.index << "\t";
	os << locus.nChrom << "\t";
	os << "2" << "\t"; //fixed number for this project
	os << locus.allele1 << "\t";
	os << locus.allele2;
	return os;
};

int main(int argc, char *argv[]) {
	// get output file name root from input file name like "xxx.gp1.frq" or ".../.../xxx.gp1.frq"
	string ext = ".gp1.frq";
	string fileName =  argv[1];
	int begin = fileName.find_last_of('/') + 1;
	int len = fileName.size() - begin - ext.size(); 
	fileName = fileName.substr(begin, len);
//	std::cout << fileName << std::endl;
	
	// pre output file and error file
	std::ofstream outPre (fileName + ".data");
	std::ofstream err (fileName + ".bayescan.err");
	if (!outPre.is_open()){
		std::cerr << "Output file was not opened." << std::endl;
		exit(1);
	}
	if (!err.is_open()){
		std::cerr << "Error file was not opened." << std::endl;
		exit(1);
	}
	
	// process input files and get data in out_pre
	std::ifstream in;
	int indexCounter = 0; // max value of int is 2147483647 // upgrade data type if needed
	for (int popCounter = 1; popCounter < argc; popCounter++){
		in.open(argv[popCounter]);
		if (!in.is_open()){
			std::cout << "Input file was not opened." << std::endl;
			exit(1);
		}
		
		outPre << "[pop]=" << popCounter << std::endl;
		err << "[pop]=" << popCounter << std::endl;
		
		std::string line;
		Locus myLocus;
		std::getline(in, line); //Discards header
		while (std::getline(in, line)) {
			std::istringstream is(line);
			if(!(is >> myLocus)){
				std::cerr << "Error on line: " << line; 
			}
			if(myLocus.nChrom == 0){
				err << "Chrom number wrong on index " << myLocus.index << ": "<< line << std::endl;
			}
			myLocus.index = ++indexCounter;
			myLocus.allele1 = round(myLocus.allele1FREQ * myLocus.nChrom);
			myLocus.allele2 = round(myLocus.allele2FREQ * myLocus.nChrom);
			outPre << myLocus << std::endl;
		}
		in.close();
		
		outPre << "" << std::endl;
		err << "" << std::endl;
		
		// initial pop counter unless it's the last input file
		if (popCounter != argc - 1)
			indexCounter = 0;
	}
	outPre.close();
	
	// packing output file
	std::ifstream data (fileName + ".data");
	std::ofstream out (fileName + ".bayescan");
	if (!data.is_open()){
		std::cout << "Data file was not opened." << std::endl;
		exit(1);
	}
	if (!out.is_open()){
		std::cerr << "Output file was not opened." << std::endl;
		exit(1);
	}
	out << "[loci]=" << indexCounter << std::endl;
	out << "" << std::endl;
	out << "[populations]=" << argc - 1 << std::endl;
	out << "" << std::endl;
	out << data.rdbuf();
	out.close();
	data.close();
	
	std:remove((fileName + ".data").c_str());
	
	return 0;
}