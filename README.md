MIT License

ABImageWrapper designed to handle image temporary caching. In case when you need to manage multiple UIImages which can't be loaded in memory all at once wrapper will store them in temporary directory. Wrapper object itself will handle only file pathes and load them when you need it. Because imageNamed method used in wrapper caches UIImages and clear them automatically on low memory warnings you don't need to take any aditional measures. Also wrapper can scale images and cache them for reuses between application launching in case your network server support this approach.

For example you can use ABImageWrapper when you provide user option to take from camera or choose from album multiple photos which will be later uploaded to server. Full sized photos can deplete all available memory very fast. In this case usualy you need to store them in some temporary directory and handle memory warning urself. Wrapper will make it a lot easyer.

Usage example:

//Create wrapper. You don't need to keep your image after wrapper is created 
ABImageWrapper* wrapper = [ABImageWrapper createWithUIImage:image];

//Get your original image 
UIImage* full_sized_image = [wrapper fullSized];

//Scaled image for some previews 
UIImage* small_image = [wrapper smallSize];

//128 128 image with quality of 0.5. Quality parameter is used for UIImageJPEGRepresentation 
UIImage* custom_image = [wrapper customSize:CGSizeMake(128, 128) withQuality:0.5];

//Cache image to use it next time application launch
NSString* cache_id = [wrapper cacheForReuse];

//Create wrapper from cache. You can check if [cached_wrapper fullSized] is Nil later to check if image was cached and do something about if it wasn't. For example download image by cache id from server and cache it in application. 
ABImageWrapper* cached_wrapper = [ABImageWrapper createWithCacheID:cache_id];

//In case [cached_wrapper fullSized] is Nil and you downloaded corresponding image from server 
[cached_wrapper fillWithImage:image_from_server]; 
[cached_wrapper cacheForReuse];

Thats it.

P.S. Also in case you are concerned about storage memory use during application execution you can force clear temporary or gloabal cache folder. Please read comments before doing it. If you are still using UIImages created by wrapper you can get undefined behaviour depending from were those image already rendered or not.