#ifndef CTOMLPLUSPLUS_HPP
#define CTOMLPLUSPLUS_HPP

#include <string>
#include <vector>
#include <optional>
#include <cstdint>
#include <memory>

namespace tomlpp {

struct DateValue {
    int32_t year;
    int32_t month;
    int32_t day;
};

struct TimeValue {
    int32_t hour;
    int32_t minute;
    int32_t second;
    int32_t nanosecond;
};

struct DateTimeValue {
    DateValue date;
    TimeValue time;
    bool hasOffset;
    int32_t offsetMinutes;
};

struct ParseError {
    std::string description;
    int64_t line;
    int64_t column;
};

enum class NodeType : int32_t {
    None = 0,
    String,
    Integer,
    Float,
    Boolean,
    Date,
    Time,
    DateTime,
    Array,
    Table
};

class Node;
class Document;

class Node {
public:
    Node() : _type(NodeType::None), _stringValue(), _intValue(0), _floatValue(0), _boolValue(false) {}
    
    NodeType getType() const { return _type; }
    
    std::string getString() const { return _stringValue; }
    int64_t getInteger() const { return _intValue; }
    double getFloat() const { return _floatValue; }
    bool getBoolean() const { return _boolValue; }
    DateValue getDate() const { return _dateValue; }
    TimeValue getTime() const { return _timeValue; }
    DateTimeValue getDateTime() const { return _dateTimeValue; }
    
    size_t getArraySize() const { return _arrayValue.size(); }
    Node getArrayElement(size_t index) const {
        if (index < _arrayValue.size()) return _arrayValue[index];
        return Node();
    }
    
    size_t getTableSize() const { return _tableKeys.size(); }
    std::string getTableKey(size_t index) const {
        if (index < _tableKeys.size()) return _tableKeys[index];
        return "";
    }
    std::optional<Node> getTableValue(const std::string& key) const {
        for (size_t i = 0; i < _tableKeys.size(); ++i) {
            if (_tableKeys[i] == key) return _tableValues[i];
        }
        return std::nullopt;
    }
    
    static Node makeString(const std::string& value) {
        Node n;
        n._type = NodeType::String;
        n._stringValue = value;
        return n;
    }
    
    static Node makeInteger(int64_t value) {
        Node n;
        n._type = NodeType::Integer;
        n._intValue = value;
        return n;
    }
    
    static Node makeFloat(double value) {
        Node n;
        n._type = NodeType::Float;
        n._floatValue = value;
        return n;
    }
    
    static Node makeBoolean(bool value) {
        Node n;
        n._type = NodeType::Boolean;
        n._boolValue = value;
        return n;
    }
    
    static Node makeDate(DateValue value) {
        Node n;
        n._type = NodeType::Date;
        n._dateValue = value;
        return n;
    }
    
    static Node makeTime(TimeValue value) {
        Node n;
        n._type = NodeType::Time;
        n._timeValue = value;
        return n;
    }
    
    static Node makeDateTime(DateTimeValue value) {
        Node n;
        n._type = NodeType::DateTime;
        n._dateTimeValue = value;
        return n;
    }
    
    static Node makeArray(const std::vector<Node>& elements) {
        Node n;
        n._type = NodeType::Array;
        n._arrayValue = elements;
        return n;
    }
    
    static Node makeTable(const std::vector<std::string>& keys, const std::vector<Node>& values) {
        Node n;
        n._type = NodeType::Table;
        n._tableKeys = keys;
        n._tableValues = values;
        return n;
    }

private:
    NodeType _type;
    std::string _stringValue;
    int64_t _intValue;
    double _floatValue;
    bool _boolValue;
    DateValue _dateValue;
    TimeValue _timeValue;
    DateTimeValue _dateTimeValue;
    std::vector<Node> _arrayValue;
    std::vector<std::string> _tableKeys;
    std::vector<Node> _tableValues;
};

struct ParseResult {
    bool success;
    std::optional<ParseError> error;
    Node root;
};

ParseResult parse(const std::string& input);

} // namespace tomlpp

#endif // CTOMLPLUSPLUS_HPP
