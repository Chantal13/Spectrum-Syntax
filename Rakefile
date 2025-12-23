require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/**/*_test.rb']
end

task default: :test

desc 'Generate WebP variants for local images (non-fatal)'
task :webp do
  script = File.join('scripts', 'make_webp.py')
  unless File.exist?(script)
    puts "[webp] No script at #{script}; skipping"
    next
  end

  # Prefer python3 if available
  py = ENV['PYTHON'] || 'python3'
  puts "[webp] Running #{py} #{script}"
  ok = system(py, script)
  unless ok
    puts "[webp] Skipped: python3/Pillow unavailable or conversion failed (non-fatal)"
  end
end
