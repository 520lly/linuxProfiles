///////////////////////////////////////////////////////////
//  ServiceResourceProviderBase.hpp
//  Implementation of the Class ServiceResourceProviderBase
//  Created on:      09-Nov-2016 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#include <tsd/rsi/server/serviceresourceproviderbase.hpp>
#include <tsd/rsi/common/iresourcebase.hpp>

#include <algorithm>

namespace tsd { namespace rsi { namespace server {

ServiceResourceProviderBase::ServiceResourceProviderBase(const std::string& serviceProviderName, const uint16_t portNr)
   : ServiceProviderBase(serviceProviderName, portNr)
{

}

ServiceResourceProviderBase::~ServiceResourceProviderBase()
{

}

void ServiceResourceProviderBase::registerResourceCreateFunction(const std::string& resourceName, ResourceCreateFunctionPtr createResourceFunction)
{
   registerServiceResource(m_serviceProviderName, resourceName, this);
   m_resourceCreateFuncPtrMap[resourceName] = createResourceFunction;
}

void ServiceResourceProviderBase::registerResourceGetFunction(const std::string& resourceName, ResourceGetFunctionPtr getResourceFunction)
{
   registerServiceResource(m_serviceProviderName, resourceName, this);
   m_resourceGetFuncPtrMap[resourceName] = getResourceFunction;
}

common::HttpStatusCode ServiceResourceProviderBase::callCreateResourceFunction(const std::string& resourceName, std::unique_ptr<common::data::Value> values)
{
   common::HttpStatusCode httpStatusCode = common::HttpStatusCode::NotFound;
   ResourceCreateFuncPtrMap::iterator it = m_resourceCreateFuncPtrMap.find(resourceName);
   if(it != m_resourceCreateFuncPtrMap.end())
	{
      ResourceCreateFunctionPtr funcPtr = it->second;
      httpStatusCode = funcPtr(resourceName, std::move(values));
   }
	else
	{ /* TODO: write out some kind of error ??? */ 
	}
   return httpStatusCode;
}

common::HttpStatusCode ServiceResourceProviderBase::callGetResourceFunction(const std::string& resourceName, common::data::Value*& valueOut, const common::queries::Query& query)
{
   common::HttpStatusCode httpStatusCode = common::HttpStatusCode::NotFound;
   ResourceGetFuncPtrMap::iterator it = m_resourceGetFuncPtrMap.find(resourceName);
   if(it != m_resourceGetFuncPtrMap.end())
	{
      common::IResourceBase* resourceOut = nullptr;

      ResourceGetFunctionPtr funcPtr = it->second;
      httpStatusCode = funcPtr(resourceOut, query);

      if(resourceOut == nullptr)
      {
         valueOut = new common::data::Array();

      }
      else if(isStatusCodeValid(httpStatusCode))
      {
         valueOut = resourceOut->serialize().release();
         delete resourceOut;
      }
	}
	else
	{ /* TODO: write out some kind of error ??? */ 
   }
   return httpStatusCode;
}

void ServiceResourceProviderBase::checkResource(const std::string& resourceName)
{
   if(std::find(m_resourcesVector.begin(), m_resourcesVector.end(), resourceName) == m_resourcesVector.end())
   {
       m_resourcesVector.push_back(resourceName);
       registerResource(resourceName);
   }
}

}}}
