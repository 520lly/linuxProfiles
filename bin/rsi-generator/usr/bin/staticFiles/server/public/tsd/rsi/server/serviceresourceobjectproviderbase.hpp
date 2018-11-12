///////////////////////////////////////////////////////////
//  ServiceResourceObjectProviderBase.hpp
//  Implementation of the Class ServiceResourceObjectProviderBase
//  Created on:      09-Nov-2016 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#ifndef TSD_RSI_SERVER_SERVICERESOURCEOBJECTPROVIDERBASE_HPP
#define TSD_RSI_SERVER_SERVICERESOURCEOBJECTPROVIDERBASE_HPP

#include <map>
#include <typeinfo>
#include <functional>
#include <list>
#include <string>
#include <memory>

#include <tsd/rsi/common/data/value.hpp>
#include <tsd/rsi/server/serviceresourceproviderbase.hpp>

namespace tsd { namespace rsi { namespace common {

class IObjectBase;

}

namespace server {

class ServiceResourceObjectProviderBase : public ServiceResourceProviderBase
{
private:
   ServiceResourceObjectProviderBase() : ServiceResourceProviderBase("", 0) {}

protected:
   typedef std::function<common::HttpStatusCode(std::unique_ptr<dataformats::data::Value> values, std::string& elementUriOut)> ElementCreateFunctionPtr;
   typedef std::map<std::string, ElementCreateFunctionPtr> ElementCreateFuncPtrMap;
   ElementCreateFuncPtrMap m_elementCreateFuncPtrMap;

   typedef std::function<common::HttpStatusCode(const std::string& objectId, const common::queries::Query& query)> ElementDeleteFunctionPtr;
   typedef std::map<std::string, ElementDeleteFunctionPtr> ElementDeleteFuncPtrMap;
   ElementDeleteFuncPtrMap m_elementDeleteFuncPtrMap;

   typedef std::function<common::HttpStatusCode(const std::string& objectId, common::IObjectBase*& object, const common::queries::Query& query)> ElementGetFunctionPtr;
   typedef std::map<std::string, ElementGetFunctionPtr> ElementGetFuncPtrMap;
   ElementGetFuncPtrMap m_elementGetFuncPtrMap;

   typedef std::function<common::HttpStatusCode(const std::string& objectId, std::unique_ptr<dataformats::data::Value> values, std::string& elementUriOut)> ElementUpdateFunctionPtr;
   typedef std::map<std::string, ElementUpdateFunctionPtr> ElementUpdateFuncPtrMap;
   ElementUpdateFuncPtrMap m_elementUpdateFuncPtrMap;

   common::HttpStatusCode callCreateObjectFunction       (const std::string& resourceName, std::unique_ptr<dataformats::data::Value> values, std::string& elementUriOut);
   common::HttpStatusCode callDeleteObjectFunction       (const std::string& resourceName, const std::string& objectId, const common::queries::Query& query);
   common::HttpStatusCode callGetObjectFunction          (const std::string& resourceName, const std::string& objectId, dataformats::data::Value*& valueOut, const common::queries::Query& query);
   common::HttpStatusCode callUpdateObjectFunction       (const std::string& resourceName, const std::string& objectId, std::unique_ptr<dataformats::data::Value> values, std::string& elementUriOut);

public:
   ServiceResourceObjectProviderBase(const std::string& serviceProviderName, const uint16_t portNr);
   virtual ~ServiceResourceObjectProviderBase();

//   static inline std::string getClassName() { return "ServiceResourceObjectProviderBase"; }

   void registerElementCreateFunction(const std::string& resourceName, const std::string& objectName, ElementCreateFunctionPtr createObjectFunction);
   void registerElementDeleteFunction(const std::string& resourceName, const std::string& objectName, ElementDeleteFunctionPtr deleteObjectFunction);
   void registerElementGetFunction   (const std::string& resourceName, const std::string& objectName, ElementGetFunctionPtr getObjectFunction);
   void registerElementUpdateFunction(const std::string& resourceName, const std::string& objectName, ElementUpdateFunctionPtr updateObjectFunction);
};

}}}

#endif

