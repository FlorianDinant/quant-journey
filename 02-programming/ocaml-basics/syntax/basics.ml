(* OCaml basics: syntax and functions *)

let square x = x *. x
let mean a b = (a +. b) /. 2.0
let rec factorial n = if n <= 1 then 1 else n * factorial (n - 1)

let () =
  Printf.printf "Square(3.0) = %f\n" (square 3.0);
  Printf.printf "Mean(10.0, 5.0) = %f\n" (mean 10.0 5.0);
  Printf.printf "Factorial(5) = %d\n" (factorial 5)
  