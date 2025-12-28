# Experiments Log

This file tracks all experimental runs and parameter tuning.

---

## Run 1: Baseline (Default Parameters)
**Date:** 2025-12-28  
**Commit:** [insert git hash after commit]

### Parameters:
- Population size: 100
- Max generations: 250
- Crossover prob: 0.7
- Mutation prob: 0.01
- Elitism: 2
- Patience: 30

### Bounds:
- w: [-5, 5]
- c1: [-1, 2]
- c2: [-2, 1]
- sigma1, sigma2: [0.1, 2]

### Results:
**Best Model:** M = 8 Gaussians

| M  | Train MSE | Test MSE | Generations |
|----|-----------|----------|-------------|
| 1  | 0.064448  | 0.067059 | 242         |
| 2  | 0.041104  | 0.045485 | 250         |
| 3  | 0.034328  | 0.037106 | 248         |
| 4  | 0.036306  | 0.038380 | 250         |
| 5  | 0.061528  | 0.073421 | 250         |
| 6  | 0.035289  | 0.034183 | 185         |
| 7  | 0.021473  | 0.023499 | 250         |
| **8**  | **0.023460**  | **0.020746** | **235**         |
| 9  | 0.019084  | 0.021130 | 250         |
| 10 | 0.035967  | 0.040842 | 250         |
| 11 | 0.060259  | 0.058901 | 250         |
| 12 | 0.057023  | 0.064589 | 250         |
| 13 | 0.050989  | 0.053222 | 250         |
| 14 | 0.041359  | 0.047784 | 250         |
| 15 | 0.041377  | 0.046529 | 250         |

### Observations:
- M=8 achieved best test MSE (0.020746)
- Sweet spot: M=6-9
- Overfitting starts at M≥10
- Early stopping effective (M=6,8 stopped before 250 gens)
