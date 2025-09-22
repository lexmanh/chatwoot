# build and push to uef container registry cr.uef.edu.vn/uef/chatwoot:development 
# and then tag to cr.uef.edu.vn/uef/chatwoot:latest

# #1. build base image with args:args:
#         BUNDLE_WITHOUT: ''
#         EXECJS_RUNTIME: 'Node'
#         RAILS_ENV: 'development'
#         RAILS_SERVE_STATIC_FILES: 'false'
docker build -t cr.uef.edu.vn/uef/chatwoot:latest \
    --build-arg BUNDLE_WITHOUT='' \
    --build-arg EXECJS_RUNTIME='Node' \
    --build-arg RAILS_ENV='production' \
    --build-arg RAILS_SERVE_STATIC_FILES='false' \
    -f docker/Dockerfile .

# #2. push to uef container registry
docker push cr.uef.edu.vn/uef/chatwoot:latest