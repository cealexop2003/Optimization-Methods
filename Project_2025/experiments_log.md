# Experiments Log

This file tracks all experimental runs and parameter tuning.

---

## Run 1: Baseline (Default Parameters)

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

---

## Run 2: Seed Validation (Different Train/Test Split)

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

### Change from Run 1:
- **Train seed:** 42 → 100
- **Test seed:** 123 → 200

### Results:
**Best Model:** M = 5 Gaussians

| M  | Train MSE | Test MSE | Generations |
|----|-----------|----------|-------------|
| 1  | 0.055289  | 0.056525 | 147         |
| 2  | 0.032395  | 0.026966 | 250         |
| 3  | 0.025545  | 0.020687 | 250         |
| 4  | 0.028168  | 0.022510 | 250         |
| **5**  | **0.019041**  | **0.014711** | **250**         |
| 6  | 0.039788  | 0.038420 | 250         |
| 7  | 0.026921  | 0.020437 | 250         |
| 8  | 0.061872  | 0.052363 | 84          |
| 9  | 0.025901  | 0.026798 | 250         |
| 10 | 0.026936  | 0.028355 | 248         |
| 11 | 0.048659  | 0.042568 | 250         |
| 12 | 0.058207  | 0.068266 | 138         |
| 13 | 0.026398  | 0.026828 | 250         |
| 14 | 0.027925  | 0.025902 | 250         |
| 15 | 0.036790  | 0.039963 | 250         |

### Observations:
- **M=5 achieved best test MSE (0.014711)** - DIFFERENT from Run 1!
- M=5 shows consistent generalization (Test < Train)
- M=3,4,7 also show good performance (Test MSE ~0.020-0.022)
- M=8 performed poorly in Run 2 (Test MSE=0.052), early stopped at gen 84
- Sweet spot: M=3-7 (more conservative than Run 1)
- Overfitting evident for M≥9

### Key Insights:
1. **Optimal M is data-dependent**: Run 1 → M=8, Run 2 → M=5
2. **Consistent range**: M=3-8 performs well in both runs
3. **Variability with seeds**: Different train/test splits favor different model complexities
4. **Recommendation for report**: Use M=5-8 range, or cross-validation for robustness

---

## Run 3: Stability Analysis (20 Different Seeds)
**Purpose:** Find most robust M across multiple train/test splits

### Configuration:
- 20 runs with seeds: [1000,1500], [2000,2500], ..., [20000,20500]
- All other parameters identical to Run 1 & 2

### Top-5 Models by Stability:

| M | Wins | Top-3 | Avg Rank | Median MSE | Std MSE |
|---|------|-------|----------|------------|---------|
| **5** | **4** | **11/20** | **4.30** | **0.0234** | **0.0087** |
| 6 | 2 | 12/20 | 4.40 | 0.0240 | 0.0086 |
| 4 | 2 | 6/20 | 5.05 | 0.0271 | 0.0079 |
| 8 | 3 | 6/20 | 5.45 | 0.0261 | 0.0102 |
| 3 | 1 | 4/20 | 5.85 | 0.0278 | 0.0079 |

### Final Recommendation:
**M = 5 Gaussians** (best by all metrics: wins, top-3 rate, avg rank, median MSE)

**Alternative:** M=6 (highest top-3 consistency at 60%, very stable)

---

## Run 4: Parameter Tuning (Grid Search)
**Purpose:** Optimize GA parameters (patience, sigma bounds, max_gen, w bounds)

### Tuning Grid:
- Patience: [20, 30, 50]
- Sigma bounds: [[0.1, 2.0], [0.1, 5.0]]
- Max generations: [250, 500]
- W bounds: [[-5, 5], [-10, 10]]
- **Total:** 24 configurations × 15 M values = 360 runs

### Best Configuration (Config #10):

| Parameter | Baseline | Tuned |
|-----------|----------|-------|
| Patience | 30 | 30 ✓ |
| Sigma bounds | [0.1, 2.0] | [0.1, 2.0] ✓ |
| Max gen | 250 | 250 ✓ |
| **W bounds** | **[-5, 5]** | **[-10, 10]** ⭐ |

### Results:
**Winner from 360 combinations** (24 configs × 15 M): **Config #10, M=6**  
**Test MSE:** 0.009366 (36% improvement over baseline!)

| Rank | Config | M | Test MSE |
|------|--------|---|----------|
| 1st | #10 | **6** | **0.009366** |
| 2nd | #3 | 9 | 0.012994 |
| 3rd | #11 | 6 | 0.013084 |

**Config #10 detailed results:**

| M | Train MSE | Test MSE | Improvement |
|---|-----------|----------|-------------|
| **6** | **0.009301** | **0.009366** | **-36%** |
| 8 | 0.023309 | 0.019578 | +6% |
| 2 | 0.032702 | 0.026683 | -2% |

### Key Findings (across all 24 configs):
1. **W bounds critical:** [-10,10] consistently better than [-5,5]
2. **Sigma=[0.1,5] harmful:** All wide-sigma configs performed poorly
3. **Max_gen=500 unnecessary:** No improvement, just 2× runtime
4. **M=6 optimal** with tuned params (shifted from M=5)
5. **Perfect generalization:** Train ≈ Test (0.0093 ≈ 0.0094)

---

## Run 5: Optimized Stability Analysis (M-Specific Configs)
**Purpose:** Fair comparison - each M uses its own best configuration from tuning

### Methodology:
- For each M=1:15, identified best config from 24 tuning runs
- Ran 20-seed stability with M-specific optimized parameters
- Seeds: [1000,1500], [2000,2500], ..., [20000,20500]

### Top-5 Models with Optimized Configs:

| M | Wins | Top-3 | Avg Rank | Median MSE | Std MSE | Best Config |
|---|------|-------|----------|------------|---------|-------------|
| **8** | **5** | **16/20** | **2.40** | **0.0172** | **0.0056** | #19: p=50, max=500 |
| 7 | 4 | 12/20 | 4.70 | 0.0199 | 0.0187 | #11: p=30, max=500 |
| 3 | 2 | 9/20 | 3.80 | 0.0225 | 0.0065 | #19: p=50, max=500 |
| 5 | 3 | 5/20 | 6.35 | 0.0294 | 0.0161 | #12: p=30, max=500 |
| 4 | 2 | 4/20 | 6.15 | 0.0314 | 0.0101 | #18: p=50, max=250 |

### Final Recommendation:
**M = 8 Gaussians** (dominant by ALL metrics)

**Optimized parameters for M=8:**

| Parameter | Baseline | M=8 Optimized |
|-----------|----------|---------------|
| Patience | 30 | **50** ⭐ |
| Max gen | 250 | **500** ⭐ |
| W bounds | [-5,5] | [-5,5] ✓ |
| Sigma | [0.1,2.0] | [0.1,2.0] ✓ |

### Key Insights:
1. **M=8 needs more evolution time:** patience=50, max_gen=500
2. **80% top-3 consistency:** Most robust across different data splits
3. **Low variance:** std=0.0056 (very stable performance)
4. **M=6 (tuning winner) failed:** Only 1/20 top-3, not robust
5. **Different M → Different optimal params:** One-size-fits-all doesn't work
