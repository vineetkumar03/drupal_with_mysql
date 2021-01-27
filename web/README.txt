README 


dokcerfile
Dockerfile2


both will work 
download nad test it
Please follow the rules to create an image

1. Please replace source/site folder from your website site folder and do schanges in settings.php accordingly.
2. All files should have full permission
3. Run command to build an image: docker build -t  any_image_name:any_tag_name .
4. Dot is mendetory at the last . This command run where the Dockerfile is situated.
5. Docker command to Check Image is present or not: docker images
6. Push image to chub repository: dokcer push any_image_name:any_tag_name
