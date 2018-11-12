#ifndef TSD_RSI_IOBJECTBASE_HPP
#define TSD_RSI_IOBJECTBASE_HPP

#include <string>
#include <memory>

// include all preh json parser headers here, so in generated derived classes the parser can be
// used without managing every single necessary include (hard to handle in code generator)
#include <tsd/rsi/common/json/parser.hpp>
#include <tsd/rsi/common/data/integer.hpp>
#include <tsd/rsi/common/data/string.hpp>
#include <tsd/rsi/common/data/array.hpp>
#include <tsd/rsi/common/data/object.hpp>
#include <tsd/rsi/common/data/float.hpp>
#include <tsd/rsi/common/data/boolean.hpp>

namespace tsd { namespace rsi { namespace common {

class IObjectBase
{
private:
   IObjectBase() {}  // hide standard constructor

protected:
   std::string m_elementName;

public:
   IObjectBase(std::string elementName) : m_elementName(elementName) {}
   virtual ~IObjectBase() {}

   virtual std::unique_ptr<tsd::rsi::common::data::Value> serialize() const = 0;
   virtual bool deserialize(tsd::rsi::common::data::Value* element) = 0;

//   static std::string getClassName() { return "IObjectBase"; }
};

}}}

#endif
