///////////////////////////////////////////////////////////
//  ServiceProviderBase.cpp
//  Implementation of the Class ServiceProviderBase
//  Created on:      09-Nov-2016 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#include <tsd/rsi/server/serviceproviderbase.hpp>

namespace tsd { namespace rsi { namespace server {

using namespace tsd::rsi::server;

ServiceProviderBase::ServiceProviderBase(const std::string& serviceProviderName, const uint16_t portNr)
   : m_serviceProviderName(serviceProviderName)
   , m_dispatcher(server::dispatcher::IDispatcher::createDispatcher(portNr, false))
{
   registerServiceResource(m_serviceProviderName, this);
}

ServiceProviderBase::~ServiceProviderBase()
{

}

bool ServiceProviderBase::registerServiceResource(const std::string& serviceName, rsi::server::dispatcher::IAdaption* adaption)
{
   return m_dispatcher->registerServiceResource(serviceName, adaption);
}

bool ServiceProviderBase::registerServiceResource(const std::string& serviceName, const std::string& resourceName, rsi::server::dispatcher::IAdaption* adaption)
{
   return m_dispatcher->registerServiceResource(serviceName, resourceName, adaption);
}

bool ServiceProviderBase::unregisterServiceResource(const std::string& serviceName)
{
   return m_dispatcher->unregisterServiceResource(serviceName);
}

bool ServiceProviderBase::unregisterServiceResource(const std::string& serviceName, const std::string& resourceName)
{
   return m_dispatcher->unregisterServiceResource(serviceName, resourceName);
}

bool ServiceProviderBase::getResources(const std::string& serviceName, rsi::server::dispatcher::ResourceMap& resourceMapOut) const
{
   return m_dispatcher->getResources(serviceName, resourceMapOut);
}

long ServiceProviderBase::getElementPointerId() const
{
   return 0;
}

void ServiceProviderBase::handleRequest(RequestDescription& requestDescription)
{
   const requestType::RequestType reqType = requestDescription.request.m_Type;
   const std::string& resourceName = requestDescription.request.m_Resource;
   const std::string& objectId = requestDescription.request.m_Element;
   std::string elementUriOut;

   common::HttpStatusCode httpStatusCode = common::HttpStatusCode::NotFound;
   common::data::Value* returnValues = nullptr;

   switch(reqType)
   {
    case requestType::DeleteElement:
       httpStatusCode = callDeleteObjectFunction(resourceName, objectId, requestDescription.request.m_Query);
          break;
   /*       case requestType::DeleteResource:
       httpStatusCode = callDeleteResourceFunction(resourceName);
          break;*/
    case requestType::GetResource:
       httpStatusCode = callGetResourceFunction(resourceName, returnValues, requestDescription.request.m_Query);
       break;
    case requestType::GetElement:
       httpStatusCode = callGetObjectFunction(resourceName, objectId, returnValues, requestDescription.request.m_Query);
       break;
    case requestType::PostResource:
       httpStatusCode = callCreateObjectFunction(resourceName, std::move(requestDescription.request.m_Data), elementUriOut);
       break;
   case requestType::PostElement:
       httpStatusCode = callUpdateObjectFunction(resourceName, objectId, std::move(requestDescription.request.m_Data), elementUriOut);
       break;
   case requestType::PutElement:
       httpStatusCode = callCreateObjectFunction(resourceName, std::move(requestDescription.request.m_Data), elementUriOut);
       break;
   default:
      break;// TODO: write out some kind of error ???
   }

   switch(reqType)
   {
   case requestType::PostElement:
   case requestType::PostResource:
   case requestType::PutElement:
      requestDescription.confirmWithLocation(elementUriOut, httpStatusCode);
      break;
   default:
      if(returnValues == nullptr)
      {
         returnValues = (common::data::Value*)new common::data::Object();
      }

      std::unique_ptr<common::data::Value> returnValuesPtr(returnValues);
      requestDescription.confirmWithData(std::move(returnValuesPtr), httpStatusCode, false);
      break;
   }
}

void ServiceProviderBase::sendEvent(server::SubscriptionId id, std::unique_ptr<common::data::Value> value)
{
    m_dispatcher->sendEvent(id, std::move(value));
}

void ServiceProviderBase::sendEvent(const std::string& service, const std::string& resource, std::unique_ptr<common::data::Value> value)
{
    m_dispatcher->sendEvent(service, resource, std::move(value));
}

void ServiceProviderBase::sendEvent(const std::string& service, const std::string& resource, const std::string& element, std::unique_ptr<common::data::Value> value)
{
    m_dispatcher->sendEvent(service, resource, element, std::move(value));
}

}}}
