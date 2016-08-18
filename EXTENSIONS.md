# Using Material in App Extensions

You can use compile time flags to disable the subset of features that are not safe for use in app extensions.

This has to be done on a whole-project basis, so you will lose the relevant functionality in your whole project (not just the extension).

## Things you can’t do in an extension

- Get or set the status bar style
- Show or hide the status bar
- Get the orientation


## How to stay safe

Material uses conditional compilation to disable features.

To disable unsafe features, change the ‘Other Swift Flags’ in ‘Build Settings’ to 

$(inherited)
"-DMaterial_APP_EXTENSIONS"



## CocoaPods

alternatively if you are using cocoa pods, then you can add this post-install script to your pod file


	post_install do |installer|
	  installer.pods_project.targets.each do |target|
	    if target.name.end_with? "Material"
	        target.build_configurations.each do |build_configuration|
	            #if build_configuration.build_settings['APPLICATION_EXTENSION_API_ONLY'] == 'YES'
	            build_configuration.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '"-DMATERIAL_APP_EXTENSIONS"']
	            #end
	        end
	    end
	  end
	end
	

(note - the check for `APPLICATION_EXTENSION_API_ONLY` does not seem to be working currently, so it is commented out!)