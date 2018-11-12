///////////////////////////////////////////////////////////
//  ServiceResourceObjectProviderBase.cpp
//  Implementation of the Class ServiceResourceObjectProviderBase
//  Created on:      09-Nov-2016 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#include <tsd/rsi/server/serviceresourceobjectproviderbase.hpp>
#include <tsd/rsi/common/iobjectbase.hpp>

namespace tsd { namespace rsi { namespace server {

ServiceResourceObjectProviderBase::ServiceResourceObjectProviderBase(const std::string& serviceProviderName, const uint16_t portNr)
   : ServiceResourceProviderBase(serviceProviderName, portNr)
{

}

ServiceResourceObjectProviderBase::~ServiceResourceObjectProviderBase()
{

}

void ServiceResourceObjectProviderBase::registerElementCreateFunction(const std::string& resourceName, const std::string& /*objectName*/, ElementCreateFunctionPtr createObjectFunction)
{
   registerServiceResource(m_serviceProviderName, resourceName, this);
   m_elementCreateFuncPtrMap[resourceName] = createObjectFunction;  // by now just resource name is saved, because all objects are unique -> no name is present in two different resources; if this changes, save object functions under mentioning the resource
}

void ServiceResourceObjectProviderBase::registerElementDeleteFunction(const std::string& resourceName, const std::string& /*objectName*/, ElementDeleteFunctionPtr deleteObjectFunction)
{
   registerServiceResource(m_serviceProviderName, resourceName, this);
   m_elementDeleteFuncPtrMap[resourceName] = deleteObjectFunction;  // by now just resource name is saved, because all objects are unique -> no name is present in two different resources; if this changes, save object functions under mentioning the resource
}

void ServiceResourceObjectProviderBase::registerElementGetFunction(const std::string& resourceName, const std::string& /*objectName*/, ElementGetFunctionPtr getObjectFunction)
{
   registerServiceResource(m_serviceProviderName, resourceName, this);
   m_elementGetFuncPtrMap[resourceName] = getObjectFunction;  // by now just resource name is saved, because all objects are unique -> no name is present in two different resources; if this changes, save object functions under mentioning the resource
}

void ServiceResourceObjectProviderBase::registerElementUpdateFunction(const std::string& resourceName, const std::string& /*objectName*/, ElementUpdateFunctionPtr updateObjectFunction)
{
   registerServiceResource(m_serviceProviderName, resourceName, this);
   m_elementUpdateFuncPtrMap[resourceName] = updateObjectFunction;  // by now just resource name is saved, because all objects are unique -> no name is present in two different resources; if this changes, save object functions under mentioning the resource
}

common::HttpStatusCode ServiceResourceObjectProviderBase::callCreateObjectFunction(const std::string& resourceName, std::unique_ptr<common::data::Value> values, std::string& elementUriOut)
{
   common::HttpStatusCode httpStatusCode = common::HttpStatusCode::NotFound;
   ElementCreateFuncPtrMap::iterator it = m_elementCreateFuncPtrMap.find(resourceName);
   if(it != m_elementCreateFuncPtrMap.end())
   {
      ElementCreateFunctionPtr funcPtr = it->second;
      httpStatusCode = funcPtr(std::move(values), elementUriOut);
   }
   else
   { /* TODO: write out some kind of error ??? */
   }
   return httpStatusCode;
}

common::HttpStatusCode ServiceResourceObjectProviderBase::callDeleteObjectFunction(const std::string& resourceName, const std::string& objectId, const common::queries::Query& query)
{
   common::HttpStatusCode httpStatusCode = common::HttpStatusCode::NotFound;
   ElementDeleteFuncPtrMap::iterator it = m_elementDeleteFuncPtrMap.find(resourceName);
   if(it != m_elementDeleteFuncPtrMap.end())
   {
      ElementDeleteFunctionPtr funcPtr = it->second;
      httpStatusCode = funcPtr(objectId, query);
   }
   else
   { /* TODO: write out some kind of error ??? */
   }
   return httpStatusCode;
}

common::HttpStatusCode ServiceResourceObjectProviderBase::callGetObjectFunction(const std::string& resourceName, const std::string& objectId, common::data::Value*& valueOut, const common::queries::Query& query)
{
   common::HttpStatusCode httpStatusCode = common::HttpStatusCode::NotFound;
   ElementGetFuncPtrMap::iterator it = m_elementGetFuncPtrMap.find(resourceName);
   if(it != m_elementGetFuncPtrMap.end())
   {
      common::IObjectBase* objectOut = nullptr;
      ElementGetFunctionPtr funcPtr = it->second;
      httpStatusCode = funcPtr(objectId, objectOut, query);

      if(objectOut == nullptr)
      {
         valueOut = new common::data::Object();
      }
      else if(isStatusCodeValid(httpStatusCode))
      {
         valueOut = objectOut->serialize().release();
         delete objectOut;
      }
   }
   else
   { /* TODO: write out some kind of error ??? */
   }
   return httpStatusCode;
}

common::HttpStatusCode ServiceResourceObjectProviderBase::callUpdateObjectFunction(const std::string& resourceName, const std::string& objectId, std::unique_ptr<common::data::Value> values, std::string& elementUriOut)
{
   common::HttpStatusCode httpStatusCode = common::HttpStatusCode::NotFound;
   ElementUpdateFuncPtrMap::iterator it = m_elementUpdateFuncPtrMap.find(resourceName);
   if(it != m_elementUpdateFuncPtrMap.end())
   {
        ElementUpdateFunctionPtr funcPtr = it->second;
        httpStatusCode = funcPtr(objectId, std::move(values), elementUriOut);
   }
   else
   { /* TODO: write out some kind of error ??? */
   }
   return httpStatusCode;
}

}}}
