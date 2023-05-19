//
//  tokenization.cpp
//  quartzz
//
//  Created by Wijmac on 3/13/23.
//

#include<quartzz/token.hpp>
#include<vector>
#include<string>
#include<any>
using namespace std;
vector <string> strings;
void Split(string str, char separator) {
    int startIndex = 0, endIndex = 0;
    for (int i = 0; i <= str.size(); i++) {
        
        // If we reached the end of the word or the end of the input.
        if (str[i] == separator || i == str.size()) {
            endIndex = i;
            string temp;
            temp.append(str, startIndex, endIndex - startIndex);
            strings.push_back(temp);
            startIndex = endIndex + 1;
        }
    }
}
bool is_s_numeric (string SO) {
    if (SO.find("0") != string::npos || SO.find("1") != string::npos || SO.find("2") != string::npos || SO.find("3") != string::npos || SO.find("4") != string::npos || SO.find("5") != string::npos || SO.find("6") != string::npos || SO.find("6") != string::npos || SO.find("7") != string::npos || SO.find("8") != string::npos || SO.find("9") != string::npos) {
        return true;
    }
    return false;
}

bool is_white_space (string t) {
    if (t == " " || t == "\n" || t == "\r" || t == "\t") {
        return true;
    }
    return false;
}
// I love you std::any,std::variant can go fuck itself
vector <any> tokenlist;
string peek(int add,int it) {
    it += add;
    if (is_white_space(strings[it])) {
        if (is_white_space(strings[it -= 1])) {
            int e = 0;
            while (is_white_space(strings[it])) {
                e++;
                it += e;
            }
        }
        else {
            return strings[it -= 1];
        }
    }
    return strings[it];
}
const int tokenize (string sr) {
    string so = sr;
    Split(so,' ');
    int i = 0;
    
    for (string s = strings[i]; i <= strings.size(); i++ ) {
        if(is_white_space(s)) {
            i++;
        }
        else if (s.find("//") != string::npos) {
            i++;
        }
        else {
            // I wish I could use a rust match statement right now... 😔
            //Keywords
            if (s == "func") {
                tokenlist.push_back(KEYWORD_FUNCTION);
            }
            else if (s == "for") {
                tokenlist.push_back(KEYWORD_FOR);
            }
            else if (s == "TYPE") {
                tokenlist.push_back(KEYWORD_TYPE);
            }
            else if (s == "struct") {
                tokenlist.push_back(KEYWORD_STRUCT);
            }
            else if (s == "enum") {
                tokenlist.push_back(KEYWORD_ENUM);
            }
            else if (s == "while") {
                tokenlist.push_back(KEYWORD_WHILE);
            }
            else if (s == "break;") {
                tokenlist.push_back(KEYWORD_BREAK);
            }
            else if (s == "continue;") {
                tokenlist.push_back(KEYWORD_CONTINUE);
            }
            else if (s == "return") {
                tokenlist.push_back(KEYWORD_RETURN);
            }
            //Tags
            else if (s == "@!") {
                tokenlist.push_back(TAG_MAIN);
            }
            else if (s == "!#") {
                tokenlist.push_back(TAG_ASYNC);
            }
            else if (s == "!$") {
                tokenlist.push_back(TAG_META);
            }
            // Logic
            else if (s == "if") {
                tokenlist.push_back(LOGIC_IF);
            }
            else if (s == "else") {
                tokenlist.push_back(LOGIC_ELSE);
            }
            else if (s == "True") {
                tokenlist.push_back(LOGIC_TRUE);
            }
            else if (s == "False") {
                tokenlist.push_back(LOGIC_FALSE);
            }
            else if (s == "&&") {
                tokenlist.push_back(LOGIC_AND);
            }
            else if (s == "Switch") {
                tokenlist.push_back(LOGIC_SWITCH);
            }
            else if (s == "||") {
                tokenlist.push_back(LOGIC_OR);
            }
            else if (s == ">>") {
                tokenlist.push_back(LOGIC_GREATER);
            }
            else if (s == "<<") {
                tokenlist.push_back(LOGIC_LESSER);
            }
            else if (s == "==") {
                tokenlist.push_back(LOGIC_EQUAL);
            }
            else if (s == "!=") {
                tokenlist.push_back(LOGIC_NOT_EQUAL);
            }
            else if (s == "<=") {
                tokenlist.push_back(LOGIC_LESSER_EQUAL);
            }
            else if (s == ">=") {
                tokenlist.push_back(LOGIC_GREATER_EQUAL);
            }
            //EOL
            else if (s.find(";") != string::npos) {
                tokenlist.push_back(SEMI);
            }
            //Special
            else if (s == "(") {
                if (is_s_numeric(peek(2,i).c_str())) {
                    tokenlist.push_back(E_PAREN_S);
                }
                else {
                    tokenlist.push_back(ARGS_S);
                }
            }
            else if (s == ")") {
                if (is_s_numeric(peek(-2,i).c_str())) {
                    tokenlist.push_back(E_PAREN_E);
                }
                else {
                    tokenlist.push_back(ARGS_E);
                }
            }
            // Eval
            else if (is_s_numeric(s)) {
                lits = stoi(s);
                tokenlist.push_back(lits);
            }
            else if (s == "+") {
                tokenlist.push_back(ADD);
            }
            else if (s == "-") {
                tokenlist.push_back(SUBTRACT);
            }
            else if (s == "*") {
                tokenlist.push_back(MULTIPLY);
            }
            else if (s == "/") {
                tokenlist.push_back(DIVIDE);
            }
            else if (s == "%") {
                tokenlist.push_back(MODULO);
            }
            else if (s == "=") {
                tokenlist.push_back(EQUALS);
            }
            // Types
            else if (s == "String") {
                tokenlist.push_back(TYPE_STRING);
            }
            else if (s == "Int") {
                tokenlist.push_back(TYPE_INT);
            }
            else if (s == "uInt") {
                tokenlist.push_back(TYPE_UINT);
            }
            else if (s == "bool") {
                tokenlist.push_back(TYPE_BOOL);
            }
            else if (s == "char") {
                tokenlist.push_back(TYPE_CHAR);
            }
        }
    }
    return 0;
}
