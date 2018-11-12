#ifndef TSD_RSI_SERVICE_HTTPSTATUSCODEHELPER_HPP
#define TSD_RSI_SERVICE_HTTPSTATUSCODEHELPER_HPP

#include <map>
#include <string>
#include <tsd/rsi/common/httpstatuscode.hpp>
#include <tsd/rsi/common/queries/query.hpp>

namespace tsd { namespace rsi { namespace common {

const static common::queries::Query EMPTYQUERY;

inline bool isStatusCodeValid(common::HttpStatusCode statusCode)
{
   switch(statusCode)
   {
      case common::HttpStatusCode::OK:
         return true;
      default:
         return false;
   }
}

}}}

#endif // !defined(TSD_RSI_SERVICE_HTTPSTATUSCODEHELPER_HPP)

