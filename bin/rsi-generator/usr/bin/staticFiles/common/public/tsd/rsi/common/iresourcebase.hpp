#ifndef TSD_RSI_IRESOURCEBASE_HPP
#define TSD_RSI_IRESOURCEBASE_HPP

#include <string>
#include <list>

#include <tsd/rsi/common/iobjectbase.hpp>

namespace tsd { namespace rsi { namespace common {

class IResourceBase
{
protected:
   std::string m_resourceName;
   std::list<IObjectBase*> m_elements;

public:
   IResourceBase(std::string resourceName) : m_resourceName(resourceName) {}
   virtual ~IResourceBase() {}

   virtual std::unique_ptr<common::data::Value> serialize() const=0;
   virtual bool deserialize(tsd::rsi::common::data::Value* elementValues)=0;

   inline std::string getResourceName()      { return m_resourceName; }

//   static std::string getClassName()         { return "IResourceBase"; }
};

}}}

#endif
