
def info(message)
  puts "\033[1;34m[INFO] #{message}\033[0m"
end

def warn(message)
  puts "\033[1;33m[WARN] #{message}\033[0m"
end

def error(message)
  puts "\033[1;31m[ERROR] #{message}\033[0m"
end
