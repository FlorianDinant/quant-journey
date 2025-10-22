# binomial_convergence.py
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

def simulate_binomial(n, p, trials):
    return np.random.binomial(n, p, size=trials)

def mean_vs_trials(n=10, p=0.5, trials_list=None, repeats=1000):
    if trials_list is None:
        trials_list = [100, 500, 1000, 5000, 10000, 50000, 100000]
    means = []
    for t in trials_list:
        # simulate in one batch to save time
        samples = simulate_binomial(n, p, t)
        means.append(samples.mean())
    return trials_list, means

def sweep_p(n=10, trials=10000, ps=None):
    if ps is None:
        ps = [0.1, 0.3, 0.5, 0.7, 0.9]
    rows = []
    for p in ps:
        samples = simulate_binomial(n, p, trials)
        rows.append({
            "p": p,
            "mean": samples.mean(),
            "var": samples.var(),       # population var
            "std": samples.std(),
            "se": samples.std() / np.sqrt(trials)
        })
    return pd.DataFrame(rows)

if __name__ == "__main__":
    n = 10
    p = 0.5
    trials_list, means = mean_vs_trials(n=n, p=p)
    plt.figure()
    plt.plot(trials_list, means, marker='o')
    plt.xscale('log')
    plt.axhline(n*p, linestyle='--', label='theoretical mean')
    plt.xlabel('trials (log scale)')
    plt.ylabel('sample mean')
    plt.title(f'Mean convergence (n={n}, p={p})')
    plt.legend()
    plt.grid(True)
    plt.savefig('mean_convergence.png', dpi=150)

    # sweep p
    df = sweep_p(n=n, trials=10000)
    df.to_csv('binomial_sweep_p.csv', index=False)
    print(df)
    plt.show()