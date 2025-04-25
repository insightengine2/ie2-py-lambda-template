import os
import logging

ENV_LOG_LEVEL       = "IE2-LOGGING-LEVEL"
ENV_ENV             = "IE2-ENV"
ENV_DEFAULT         = ""
LOG_LEVEL_DEFAULT   = "INFO"
ENV_DEFAULT_ENV     = "DEV"

# setup logger
logger = logging.getLogger()
loglvl = os.getenv(ENV_LOG_LEVEL, LOG_LEVEL_DEFAULT)

logger.setLevel(loglvl)

def lambda_handler(ev, ctx):
    res = "Handler finished!"
    logger.info('## ENVIRONMENT VARIABLES')
    logger.info(os.getenv('AWS_LAMBDA_LOG_GROUP_NAME', ENV_DEFAULT))
    logger.info(os.getenv('AWS_LAMBDA_LOG_STREAM_NAME', ENV_DEFAULT))
    logger.info(os.getenv(ENV_LOG_LEVEL, LOG_LEVEL_DEFAULT))
    logger.info('## EVENT')
    logger.info(ev)
    logger.info(res)

    return res