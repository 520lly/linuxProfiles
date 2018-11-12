///////////////////////////////////////////////////////////
//  genericclient.hpp
//  Implementation of the Class GenericClient
//  Created on:      20-Feb-2017 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#ifndef TSD_RSI_CLIENT_CLIENTPROVIDERBASE_HPP
#define TSD_RSI_CLIENT_CLIENTPROVIDERBASE_HPP

#include <tsd/rsi/client/rsiclient.hpp>
#include <tsd/common/logging/Logger.hpp>
#include <tsd/rsi/common/iobjectbase.hpp>
#include <tsd/rsi/common/iresourcebase.hpp>
#include <tsd/rsi/common/httpstatuscodehelper.hpp>
#include <tsd/rsi/common/queries/query.hpp>

#include <functional>

namespace tsd { namespace rsi { namespace client {

typedef std::function<void(const Response&)> CallbackFunction;

class GenericClient : public tsd::rsi::client::EventHandler, public tsd::rsi::client::ResponseHandler
{
private:
    std::string m_clientName;
    tsd::common::logging::Logger m_logger;
    static std::unique_ptr<tsd::rsi::client::IRsiClient> m_pRsiClient;      // static use, so different resources of this service (having different GenericClients instantiated) are using the same RSI Client
    static tsd::common::system::AtomicInteger m_uuidCounter;       // for now just an atomic integer is used; TODO: create real uuid!

protected:

    // TODO:
/*    void createObjectAsync    (std::string serviceName, std::string resourceName, std::unique_ptr<IObjectBase> object);
    void createResourceAsync  (std::string serviceName, std::string resourceName, std::unique_ptr<IResourceBase> object);
    void deleteObjectAsync    (std::string serviceName, std::string resourceName, std::string objectId);
    void deleteResourceAsync  (std::string serviceName, std::string resourceName);
    void getObjectAsync       (std::string serviceName, std::string resourceName, std::string objectId);
    void getResourceAsync     (std::string serviceName, std::string resourceName);
    void updateObjectAsync    (std::string serviceName, std::string resourceName, std::string objectId, std::unique_ptr<IObjectBase> object);
    void updateResourceAsync  (std::string serviceName, std::string resourceName, std::unique_ptr<IObjectBase> object);*/

public:
   GenericClient(const std::string& clientName/*, IClientHandler* clientHandler*/, const std::string& hostName, const uint16_t portNr, const std::string& cert = "", const bool useSSL = true);
   virtual ~GenericClient();

//   static std::string getClassName()        { return "GenericClient"; }

   uint32_t subscribeResource(const common::queries::Query& query, const std::string& service, const std::string& resource);
   uint32_t subscribeElement(const common::queries::Query& query, const std::string& service, const std::string& resource, const std::string& element);
   void unsubscribeResourceOrElement(const uint32_t subscriptionId);

   std::unique_ptr<Response> createObjectSync    (const std::string& serviceName, const std::string& resourceName, const common::IObjectBase& object, std::string& elementUriOut);
   std::unique_ptr<Response> createObjectSync    (const std::string& serviceName, const std::string& resourceName, const common::IObjectBase& object, const common::queries::Query& query, std::string& elementUriOut);
   std::unique_ptr<Response> deleteObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId);
   std::unique_ptr<Response> deleteObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::queries::Query& query);
   std::unique_ptr<Response> getObjectSync       (const std::string& serviceName, const std::string& resourceName, const std::string& objectId);
   std::unique_ptr<Response> getObjectSync       (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::queries::Query& query);
   std::unique_ptr<Response> getResourceSync     (const std::string& serviceName, const std::string& resourceName);
   std::unique_ptr<Response> getResourceSync     (const std::string& serviceName, const std::string& resourceName, const common::queries::Query& query);
   std::unique_ptr<Response> updateObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::IObjectBase& object, std::string& elementUriOut);
   std::unique_ptr<Response> updateObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::IObjectBase& object, const common::queries::Query& query, std::string& elementUriOut);

   tsd::rsi::client::IRsiClient* getRsiClientInstance();

};

}}}

#endif // !defined(EA_FA6C06EF_C9C6_41c1_ADD6_D5905E780714__INCLUDED_)

