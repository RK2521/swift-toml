#define TOML_HEADER_ONLY 1
// Disable assertions to handle invalid input gracefully with proper error
// messages
#define TOML_ASSERT(expr) static_cast<void>(0)
#define TOML_ASSERT_ASSUME(expr) static_cast<void>(0)
#include "include/CTomlPlusPlus.hpp"
#include "toml.hpp"

namespace tomlpp {

static Node convertNode(const toml::node &node);

static Node convertTable(const toml::table &table) {
  std::vector<std::string> keys;
  std::vector<Node> values;

  for (auto &[k, v] : table) {
    keys.push_back(std::string(k));
    values.push_back(convertNode(v));
  }

  return Node::makeTable(keys, values);
}

static Node convertArray(const toml::array &arr) {
  std::vector<Node> elements;
  for (size_t i = 0; i < arr.size(); ++i) {
    if (auto *elem = arr.get(i)) {
      elements.push_back(convertNode(*elem));
    }
  }
  return Node::makeArray(elements);
}

static Node convertNode(const toml::node &node) {
  if (node.is_string()) {
    return Node::makeString(std::string(node.as_string()->get()));
  }
  if (node.is_integer()) {
    return Node::makeInteger(node.as_integer()->get());
  }
  if (node.is_floating_point()) {
    return Node::makeFloat(node.as_floating_point()->get());
  }
  if (node.is_boolean()) {
    return Node::makeBoolean(node.as_boolean()->get());
  }
  if (node.is_date()) {
    auto d = node.as_date()->get();
    DateValue dv{d.year, static_cast<int32_t>(d.month),
                 static_cast<int32_t>(d.day)};
    return Node::makeDate(dv);
  }
  if (node.is_time()) {
    auto t = node.as_time()->get();
    TimeValue tv{static_cast<int32_t>(t.hour), static_cast<int32_t>(t.minute),
                 static_cast<int32_t>(t.second),
                 static_cast<int32_t>(t.nanosecond)};
    return Node::makeTime(tv);
  }
  if (node.is_date_time()) {
    auto dt = node.as_date_time()->get();
    DateTimeValue dtv;
    dtv.date = DateValue{dt.date.year, static_cast<int32_t>(dt.date.month),
                         static_cast<int32_t>(dt.date.day)};
    dtv.time = TimeValue{static_cast<int32_t>(dt.time.hour),
                         static_cast<int32_t>(dt.time.minute),
                         static_cast<int32_t>(dt.time.second),
                         static_cast<int32_t>(dt.time.nanosecond)};
    dtv.hasOffset = dt.offset.has_value();
    dtv.offsetMinutes = dtv.hasOffset ? dt.offset->minutes : 0;
    return Node::makeDateTime(dtv);
  }
  if (node.is_array()) {
    return convertArray(*node.as_array());
  }
  if (node.is_table()) {
    return convertTable(*node.as_table());
  }
  return Node();
}

ParseResult parse(const std::string &input) {
  ParseResult result;
  result.success = false;

  try {
    auto table = toml::parse(input);
    result.root = convertTable(table);
    result.success = true;
  } catch (const toml::parse_error &err) {
    ParseError parseError;
    parseError.description = std::string(err.description());
    parseError.line = err.source().begin.line;
    parseError.column = err.source().begin.column;
    result.error = parseError;
  }

  return result;
}

} // namespace tomlpp
