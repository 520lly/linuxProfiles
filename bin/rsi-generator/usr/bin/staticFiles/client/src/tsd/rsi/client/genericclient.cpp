///////////////////////////////////////////////////////////
//  GenericClient.hpp
//  Implementation of the Class GenericClient
//  Created on:      20-Feb-2017 13:29:57
//  Original author: uwe.kampfrath
///////////////////////////////////////////////////////////

#include <tsd/rsi/client/genericclient.hpp>

#include <tsd/rsi/client/rsiclient.hpp>

namespace tsd { namespace rsi { namespace client {

using namespace tsd::rsi::common::data;

std::unique_ptr<tsd::rsi::client::IRsiClient> GenericClient::m_pRsiClient = std::unique_ptr<tsd::rsi::client::IRsiClient>();      // static use, so different resources of this service (having different GenericClients instantiated) are using the same RSI Client
tsd::common::system::AtomicInteger GenericClient::m_uuidCounter = 0;

GenericClient::GenericClient(const std::string& clientName, const std::string& hostName, const uint16_t portNr, const std::string& cert, const bool useSSL)
   : m_clientName(clientName)
//   , m_clientHandler(clientHandler)
   , m_logger("Generic_" + clientName)
{
    if(m_pRsiClient == 0)
    {
        if(hostName.size() > 0)
        {
           m_pRsiClient = tsd::rsi::client::GetRsiClient(hostName, portNr, useSSL, cert);
        }
        else
        {
           m_pRsiClient = tsd::rsi::client::GetRsiClient(portNr, useSSL, cert);
        }
    }
}

GenericClient::~GenericClient()
{

}

/*void GenericClient::handleEvent(const RequestState& state, const Response& response)
{
    if (!state)
    {
       m_logger << tsd::common::logging::LogLevel::Error << state.m_Note << std::endl;
       return;
    }

    m_clientHandler->handleEvent(response.getData());
}

void GenericClient::handleResponse(const RequestState& state, const Response& response)
{
    if (!state)
    {
       m_logger << tsd::common::logging::LogLevel::Error << state.m_Note << std::endl;
       return;
    }

    m_clientHandler->handleResponse(response.getData());
}*/

enum RsiActions
{
    RsiCreateObject,
//    RsiCreateResource,
//    RsiCreateService,
    RsiDeleteObject,
//    RsiDeleteResource,
//    RsiDeleteService,
    RsiGetObject,
    RsiGetResource,
//    RsiGetService,
    RsiUpdateObject,
//    RsiUpdateResource,
//    RsiUpdateService
};

const std::map<RsiActions, tsd::rsi::client::RequestType> RSIANDHTTPREQUESTTYPEMAP =
{
    // TODO: what about RsiCreateObject -> PutElement?!?
     { RsiCreateObject,     tsd::rsi::client::RequestType::PostResource }
//    ,{ RsiCreateResource, tsd::rsi::client::RequestType::PutResource }     // not specified
//    ,{ RsiCreateService,  tsd::rsi::client::RequestType::GetService }      // not specified
    ,{ RsiDeleteObject,     tsd::rsi::client::RequestType::DeleteElement }
//    ,{ RsiDeleteResource, tsd::rsi::client::RequestType::DeleteResource }  // not specified
//    ,{ RsiDeleteService,  tsd::rsi::client::RequestType::DeleteService }   // not specified
    ,{ RsiGetObject,        tsd::rsi::client::RequestType::GetElement }
    ,{ RsiGetResource,      tsd::rsi::client::RequestType::GetResource}
//    ,{ RsiGetService,     tsd::rsi::client::RequestType::GetService }      // not specified
    ,{ RsiUpdateObject,     tsd::rsi::client::RequestType::PostElement }
//    ,{ RsiUpdateResource, tsd::rsi::client::RequestType::GetElement }      // not specified
//    ,{ RsiUpdateService,  tsd::rsi::client::RequestType::GetElement }      // not specified
};

using namespace common;

std::unique_ptr<Response> GenericClient::createObjectSync    (const std::string& serviceName, const std::string& resourceName, const common::IObjectBase& object, std::string& elementUriOut)
{
   return createObjectSync(serviceName, resourceName, std::move(object), EMPTYQUERY, elementUriOut);
}

std::unique_ptr<Response> GenericClient::createObjectSync    (const std::string& serviceName, const std::string& resourceName, const common::IObjectBase& object, const common::queries::Query& query, std::string& elementUriOut)
{
   std::map<std::string, std::string> queryParams;
   query.FillQueryMap(queryParams);

   tsd::rsi::client::Request request;
   request.m_Type =     RSIANDHTTPREQUESTTYPEMAP.find(RsiCreateObject)->second;
   request.m_Id =       0;
   request.m_Service =  serviceName;
   request.m_Resource = resourceName;
   request.m_Element =  "";
   request.m_Query =    queryParams;
   request.m_DataType = "";
   request.m_Data =     object.serialize();

   tsd::rsi::client::Response* response = new tsd::rsi::client::Response();
   tsd::rsi::client::RequestState returnState(m_pRsiClient->sendRequest(request, *response));

   elementUriOut = response->getLocation();

   return std::unique_ptr<Response>(response);
}

std::unique_ptr<Response> GenericClient::deleteObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId)
{
   return deleteObjectSync(serviceName, resourceName, objectId, EMPTYQUERY);
}

std::unique_ptr<Response> GenericClient::deleteObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::queries::Query& query)
{
   std::map<std::string, std::string> queryParams;
   query.FillQueryMap(queryParams);
   tsd::rsi::client::Request request;
   request.m_Type =     RSIANDHTTPREQUESTTYPEMAP.find(RsiDeleteObject)->second;
   request.m_Id =       0;
   request.m_Service =  serviceName;
   request.m_Resource = resourceName;
   request.m_Element =  objectId;
   request.m_Query =    queryParams;              // TODO: how to set query params?!?
   request.m_DataType = "";

   tsd::rsi::client::Response* response = new tsd::rsi::client::Response();
   tsd::rsi::client::RequestState returnState(m_pRsiClient->sendRequest(request, *response));

   return std::unique_ptr<Response>(response);
}

std::unique_ptr<Response> GenericClient::getObjectSync       (const std::string& serviceName, const std::string& resourceName, const std::string& objectId)
{
   return getObjectSync(serviceName, resourceName, objectId, EMPTYQUERY);
}

std::unique_ptr<Response> GenericClient::getObjectSync       (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::queries::Query& query)
{
   std::map<std::string, std::string> queryParams;
   query.FillQueryMap(queryParams);
   tsd::rsi::client::Request request;
   request.m_Type =     RSIANDHTTPREQUESTTYPEMAP.find(RsiGetObject)->second;
   request.m_Id =       0;
   request.m_Service =  serviceName;
   request.m_Resource = resourceName;
   request.m_Element =  objectId;
   request.m_Query =    queryParams;              // TODO: how to set query params?!?
   request.m_DataType = "";

   tsd::rsi::client::Response* response = new tsd::rsi::client::Response();
   tsd::rsi::client::RequestState returnState(m_pRsiClient->sendRequest(request, *response));

   return std::unique_ptr<Response>(response);
}

std::unique_ptr<Response> GenericClient::getResourceSync     (const std::string& serviceName, const std::string& resourceName)
{
   return getResourceSync(serviceName, resourceName, EMPTYQUERY);
}

std::unique_ptr<Response> GenericClient::getResourceSync     (const std::string& serviceName, const std::string& resourceName, const common::queries::Query& query)
{
   std::map<std::string, std::string> queryParams;
   query.FillQueryMap(queryParams);
   tsd::rsi::client::Request request;
   request.m_Type =     RSIANDHTTPREQUESTTYPEMAP.find(RsiGetResource)->second;
   request.m_Id =       0;
   request.m_Service =  serviceName;
   request.m_Resource = resourceName;
   request.m_Element =  "";
   request.m_Query =    queryParams;              // TODO: how to set query params?!?
   request.m_DataType = "";

   tsd::rsi::client::Response* response = new tsd::rsi::client::Response();
   tsd::rsi::client::RequestState returnState(m_pRsiClient->sendRequest(request, *response));

   return std::unique_ptr<Response>(response);
}

std::unique_ptr<Response> GenericClient::updateObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::IObjectBase& object, std::string& elementUriOut)
{
   return updateObjectSync(serviceName, resourceName, objectId, std::move(object), EMPTYQUERY, elementUriOut);
}

std::unique_ptr<Response> GenericClient::updateObjectSync    (const std::string& serviceName, const std::string& resourceName, const std::string& objectId, const common::IObjectBase& object, const common::queries::Query& query, std::string& elementUriOut)
{
   std::map<std::string, std::string> queryParams;
   query.FillQueryMap(queryParams);
   tsd::rsi::client::Request request;
   request.m_Type =     RSIANDHTTPREQUESTTYPEMAP.find(RsiUpdateObject)->second;
   request.m_Id =       0;
   request.m_Service =  serviceName;
   request.m_Resource = resourceName;
   request.m_Element =  objectId;
   request.m_Query =    queryParams;              // TODO: how to set query params?!?
   request.m_Data =     object.serialize();
   request.m_DataType = "";

   tsd::rsi::client::Response* response = new tsd::rsi::client::Response();
   tsd::rsi::client::RequestState returnState(m_pRsiClient->sendRequest(request, *response));

   elementUriOut = response->getLocation();

   return std::unique_ptr<Response>(response);
}

uint32_t GenericClient::subscribeResource(const common::queries::Query& query, const std::string& service, const std::string& resource)
{
   std::map<std::string, std::string> queriesMap;
   query.FillQueryMap(queriesMap);

   tsd::rsi::client::Request request;
   request.m_Type =     tsd::rsi::client::SubscribeResource;
   request.m_Id =       ++m_uuidCounter;
   request.m_Service =  service;
   request.m_Resource = resource;
   request.m_Element =  "";
   request.m_Query =    queriesMap;
   request.m_DataType = "";
   request.m_Data =     std::unique_ptr<common::data::Value>();

   tsd::rsi::client::Response response;
   tsd::rsi::client::RequestState state;

   return m_pRsiClient->subscribe(request, response, state, *this);
}

uint32_t GenericClient::subscribeElement(const common::queries::Query& query, const std::string& service, const std::string& resource, const std::string& element)
{
   std::map<std::string, std::string> queriesMap;
   query.FillQueryMap(queriesMap);

   tsd::rsi::client::Request request;
   request.m_Type =     tsd::rsi::client::SubscribeElement;
   request.m_Id =       ++m_uuidCounter;
   request.m_Service =  service;
   request.m_Resource = resource;
   request.m_Element =  element;
   request.m_Query =    queriesMap;
   request.m_DataType = "";
   request.m_Data =     std::unique_ptr<common::data::Value>();

   tsd::rsi::client::Response response;
   tsd::rsi::client::RequestState state;

   return m_pRsiClient->subscribe(request, response, state, *this);
}

void GenericClient::unsubscribeResourceOrElement(const uint32_t subscriptionId)
{
   m_pRsiClient->unsubscribe(subscriptionId);
}

}}}
