///////////////////////////////////////////////////////////
//  ServiceProviderBase.hpp
//  Implementation of the Class ServiceProviderBase
//  Created on:      09-Nov-2016 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#ifndef TSD_RSI_SERVER_SERVICEPROVIDERBASE_HPP
#define TSD_RSI_SERVER_SERVICEPROVIDERBASE_HPP

#include <map>
#include <typeinfo>
#include <list>
#include <memory>

#include <tsd/rsi/common/queries/query.hpp>
#include <tsd/rsi/server/requestdescription.hpp>
#include <tsd/rsi/server/dispatcher/idispatcher.hpp>
#include <tsd/rsi/server/dispatcher/iadaption.hpp>
#include <tsd/rsi/common/httpstatuscodehelper.hpp>
#include <tsd/rsi/server/requestdescription.hpp>
#include <tsd/rsi/server/subscription.hpp>
#include <tsd/rsi/common/iresourcebase.hpp>
#include <tsd/rsi/common/iobjectbase.hpp>

namespace tsd { namespace rsi { namespace server {

class ServiceProviderBase : public server::dispatcher::IAdaption
{
protected:
   std::string m_serviceProviderName;
   std::unique_ptr<server::dispatcher::IDispatcher> m_dispatcher;
   inline void registerResource(const std::string& resourceName) { registerServiceResource(m_serviceProviderName, resourceName, this); }

   virtual common::HttpStatusCode callCreateResourceFunction     (const std::string& resourceName, std::unique_ptr<dataformats::data::Value> values)=0;
   virtual common::HttpStatusCode callGetResourceFunction        (const std::string& resourceName, dataformats::data::Value*& valueOut, const common::queries::Query& query)=0;
   virtual common::HttpStatusCode callCreateObjectFunction       (const std::string& resourceName, std::unique_ptr<dataformats::data::Value> values, std::string& elementUriOut)=0;
   virtual common::HttpStatusCode callDeleteObjectFunction       (const std::string& resourceName, const std::string& objectId, const common::queries::Query& query)=0;
   virtual common::HttpStatusCode callGetObjectFunction          (const std::string& resourceName, const std::string& objectId, dataformats::data::Value*& valueOut, const common::queries::Query& query)=0;
   virtual common::HttpStatusCode callUpdateObjectFunction       (const std::string& resourceName, const std::string& objectId, std::unique_ptr<dataformats::data::Value> values, std::string& elementUriOut)=0;

public:
   ServiceProviderBase(const std::string& serviceProviderName, const uint16_t portNr);
   virtual ~ServiceProviderBase();

   virtual bool registerServiceResource(const std::string& serviceName, rsi::server::dispatcher::IAdaption* adaption);
   virtual bool registerServiceResource(const std::string& serviceName, const std::string& resourceName, rsi::server::dispatcher::IAdaption* adaption);
   virtual bool unregisterServiceResource(const std::string& serviceName);
   virtual bool unregisterServiceResource(const std::string& serviceName, const std::string& resourceName);
   virtual bool getResources(const std::string& serviceName, rsi::server::dispatcher::ResourceMap& resourceMapOut) const;
   virtual void handleRequest(tsd::rsi::server::RequestDescription& requestDescription);
   virtual long getElementPointerId() const;

   std::string getUriString()                                                                { return "/" + m_serviceProviderName + "/"; }
   std::string getUriString(const std::string& resourceName)                                 { return getUriString() + resourceName + "/"; }
   std::string getUriString(const std::string& resourceName, const std::string& elementId)   { return getUriString(resourceName) + elementId + "/"; }

   void sendEvent(server::SubscriptionId id, std::unique_ptr<dataformats::data::Value> value);
   void sendEvent(const std::string& service, const std::string& resource, std::unique_ptr<dataformats::data::Value> value);
   void sendEvent(const std::string& service, const std::string& resource, const std::string& element, std::unique_ptr<dataformats::data::Value> value);
};

}}}

#endif // !defined(EA_FA6C06EF_C9C6_41c1_ADD6_D5905E780714__INCLUDED_)

