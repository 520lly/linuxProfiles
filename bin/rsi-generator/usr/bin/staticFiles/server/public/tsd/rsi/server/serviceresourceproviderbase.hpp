///////////////////////////////////////////////////////////
//  ServiceResourceProviderBase.hpp
//  Implementation of the Class ServiceResourceProviderBase
//  Created on:      09-Nov-2016 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#ifndef TSD_RSI_SERVER_SERVICERESOURCEPROVIDERBASE_HPP
#define TSD_RSI_SERVER_SERVICERESOURCEPROVIDERBASE_HPP

#include <map>
#include <typeinfo>
#include <vector>
#include <functional>
#include <memory>

#include <tsd/rsi/common/data/value.hpp>
#include <tsd/rsi/server/serviceproviderbase.hpp>

namespace tsd { namespace rsi { namespace common {

class IResourceBase;

}

namespace server {

class ServiceResourceProviderBase : public ServiceProviderBase
{
private:
   ServiceResourceProviderBase() : ServiceProviderBase("", 0) {}
   void checkResource(const std::string& resourceName);

protected:
   typedef std::function<common::HttpStatusCode(const std::string& resourceString, std::unique_ptr<dataformats::data::Value> values)> ResourceCreateFunctionPtr;
   typedef std::map<std::string, ResourceCreateFunctionPtr> ResourceCreateFuncPtrMap;
   ResourceCreateFuncPtrMap m_resourceCreateFuncPtrMap;

   typedef std::function<common::HttpStatusCode(common::IResourceBase*& resource, const common::queries::Query& query)> ResourceGetFunctionPtr;
   typedef std::map<std::string, ResourceGetFunctionPtr> ResourceGetFuncPtrMap;
   ResourceGetFuncPtrMap m_resourceGetFuncPtrMap;

   std::vector<std::string> m_resourcesVector;

   common::HttpStatusCode callCreateResourceFunction(const std::string& resourceName, std::unique_ptr<dataformats::data::Value> values);
   common::HttpStatusCode callGetResourceFunction(const std::string& resourceName, dataformats::data::Value*& valueOut, const common::queries::Query& query);

public:
   ServiceResourceProviderBase(const std::string& serviceProviderName, const uint16_t portNr);
   virtual ~ServiceResourceProviderBase();

   void registerResourceCreateFunction	(const std::string& resourceName, ResourceCreateFunctionPtr createObjectFunction);
   void registerResourceGetFunction     (const std::string& resourceName, ResourceGetFunctionPtr getObjectFunction);
};

}}}

#endif // !defined(TSD_RSI_SERVER_SERVICERESOURCEPROVIDERBASE_HPP)

