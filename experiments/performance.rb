require './x'
require 'benchmark'

lambdas = [1024,2048,4096]

lambdas.each_with_index do |lambda,i|
  code = 0
  beta = 0
  m = 0
  m1 = 0
  m2 = 0
  beta1 = 0
  beta2 = 0

  puts "========= BEGIN lambda = #{lambda} ======\n\n"
  puts "Setup"
  puts res_setup = Benchmark.measure {
    code = X::MSHCode.new(lambda)
  }

  puts "\n\n"

  puts "Encode"
  puts res_encode = Benchmark.measure {
    beta = code.encode(X::Tools.random_number(8))
  }

  puts "\n\n"

  puts "Decode"
  puts res_decode = Benchmark.measure {
    m = code.decode(beta)
  }

  puts "\n\n"

  beta1 = code.encode(X::Tools.random_number(8))
  beta2 = code.encode(X::Tools.random_number(8))

  puts "Addition"
  puts res_addition = Benchmark.measure {
    beta1_add_beta2 = code.add(beta1,beta2)
  }

  puts "\n\n"

  puts "Multiplication"
  puts res_multiplication = Benchmark.measure {
    beta1_mul_beta2 = code.mul(beta1,beta2)
  }

  puts "\n\n"

  a = Array.new(4){ X::Tools.random_number(8) }
  b = Array.new(4){ X::Tools.random_number(8) }
  beta_a = 0
  beta_b = 0

  puts "Encoding 4D vector a"
  puts res_encoding_vector =  Benchmark.measure {
    beta_a = a.map{|aa| code.encode(aa)}
  }

  puts "\n\n"

  puts "Encoding 4D vector b"
  puts Benchmark.measure {
    beta_b = b.map{|bb| code.encode(bb)}
  }

  puts "\n\n"

  puts "Decoding 4D vector a"
  puts res_decoding_vector = Benchmark.measure {
    a_d = beta_a.map{|aa| code.decode(aa)}
  }

  puts "\n\n"

  puts "Encoding 4D vector b"
  puts Benchmark.measure {
    b_d = beta_b.map{|bb| code.decode(bb)}
  }

  puts "\n\n"

  puts "Calculating a dot b"
  puts res_dot = Benchmark.measure {
    beta_a_dot_beta_b_1 = code.add(code.mul(beta_a[0],beta_b[0]),code.mul(beta_a[1],beta_b[1]))
    beta_a_dot_beta_b_2 = code.add(code.mul(beta_a[2],beta_b[2]),code.mul(beta_a[3],beta_b[3]))
    beta_a_dot_beta_b = code.add(beta_a_dot_beta_b_1,beta_a_dot_beta_b_2)
  }

  puts "\n\n"

  string = "
  \\begin{table} \n
    \\caption{Experiment run with $\\lambda = #{lambda}$} \n
    \\label{tab:performance-#{i + 1}} \n
    \\centering \n
    \\begin{tabular}{rrrr} \n
      \\hline \n
      Algorithm & Time (seconds) \\\\ \n
      \\hline \n
      Setup & $#{"%f" % res_setup.real}$ \\\\ \n
      Encode & $#{"%f" % res_encode.real}$ \\\\ \n
      Decode & $#{"%f" % res_decode.real}$ \\\\ \n
      Addition & $#{"%f" % res_addition.real}$ \\\\ \n
      Multiplication & $#{"%f" % res_multiplication.real}$ \\\\ \n
      Encoding 4D vector & $#{"%f" % res_encoding_vector.real}$ \\\\ \n
      Decoding 4D vector & $#{"%f" % res_decoding_vector.real}$ \\\\ \n
      Dot product 4D  & $#{"%f" % res_dot.real}$ \\\\ \n
    \\hline \n
  \\end{tabular} \n
  \\end{table} \n
  "

  puts string

  puts "\n\n"

  puts "================================================="
  puts "\n\n"
end
