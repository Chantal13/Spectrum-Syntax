diff --git a//dev/null b/_plugins/image_exists_filter.rb
index 0000000000000000000000000000000000000000..64b7f986d57e27acfed4cbfa34f6e129fe9f48a0 100644
--- a//dev/null
+++ b/_plugins/image_exists_filter.rb
@@ -0,0 +1,33 @@
+# frozen_string_literal: true
+
+module Jekyll
+  # Liquid filter that verifies image paths before rendering.
+  # If the path points to a remote URL, return it unchanged.
+  # Otherwise, return the path when the file exists or a placeholder
+  # when it does not.
+  module ImageExistsFilter
+    PLACEHOLDER = '/assets/tumbling/coming_soon.jpg'
+
+    # Checks whether an image path exists on disk.
+    # @param input [String] raw path or an HTML tag containing a `src` attribute
+    # @param placeholder [String] path to use when the image is missing
+    # @return [String] either the original path or the placeholder
+    def image_exists(input, placeholder = PLACEHOLDER)
+      return placeholder if input.nil? || input.empty?
+
+      path = input.to_s
+      path = path[/src\s*=\s*['"]([^'"]+)['"]/i, 1] || path
+
+      # Skip local existence checks for remote URLs
+      return path if path.start_with?('http://', 'https://')
+
+      site_source = @context.registers[:site].source
+      normalized = path.sub(%r{^/}, '')
+      absolute = File.expand_path(normalized, site_source)
+
+      File.exist?(absolute) ? path : placeholder
+    end
+  end
+end
+
+Liquid::Template.register_filter(Jekyll::ImageExistsFilter)
