(* probability_basics.ml
   Simulation d'une Binomiale avec moyenne, variance empirique et IC 95% *)

let simulate_binomial n p =
  let rec loop i successes =
    if i = n then successes
    else
      let x = Random.float 1.0 in
      let successes = if x < p then successes + 1 else successes in
      loop (i + 1) successes
  in
  loop 0 0

let stats_binomial n p trials =
  let sum = ref 0.0 in
  let sumsq = ref 0.0 in
  for i = 1 to trials do
    let x = float_of_int (simulate_binomial n p) in
    sum := !sum +. x;
    sumsq := !sumsq +. (x *. x)
  done;
  let mean = !sum /. float_of_int trials in
  let variance_emp = (!sumsq /. float_of_int trials) -. (mean *. mean) in
  (* Standard error of the mean *)
  let stddev = sqrt variance_emp in
  let se = stddev /. sqrt (float_of_int trials) in
  (* 95% CI using normal approx *)
  let z = 1.96 in
  let ci_low = mean -. z *. se in
  let ci_high = mean +. z *. se in
  (mean, variance_emp, stddev, se, ci_low, ci_high)

let () =
  Random.self_init ();
  let n = 10 in
  let p = 0.5 in
  let trials = 10_000 in
  let mean, var_emp, sd, se, ci_low, ci_high = stats_binomial n p trials in
  Printf.printf "Simulated mean: %f\n" mean;
  Printf.printf "Empirical variance: %f (sd=%f)\n" var_emp sd;
  Printf.printf "Standard error: %f\n" se;
  Printf.printf "95%% CI for mean: [%f, %f]\n" ci_low ci_high;
  Printf.printf "Theoretical mean: %f, theoretical variance: %f\n"
    (float_of_int n *. p) (float_of_int n *. p *. (1.0 -. p))