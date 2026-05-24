# Memory-Bounded Subspace Tracking for Real-Time Anomaly Detection over Streams (Submitted to CIKM 2026)

## Abstract
Real-time detection of anomalous traffic patterns is critical for network security and reliability. Traffic anomalies often appear as unusual changes that span multiple links simultaneously, making multi-dimensional tensor representations a natural structure. However, in dynamic streaming network environments, the traffic tensor grows indefinitely over time, and directly storing and analyzing it for anomaly detection becomes impractical under memory and computational constraints. 

To address this, we propose CTensor, a memory-bounded one-pass streaming method that maintains a compact tensor $\mathcal{C}$ approximating the ever-growing traffic tensor $\mathcal{M}$ while preserving its dominant subspace. We provide theoretical guarantees on the projection subspace error of $\mathcal{C}$ with respect to $\mathcal{M}$. 

Built upon CTensor, we develop CTensor-AD, a lightweight online anomaly detection method that uses the subspace of $\mathcal{C}$ to compute a closed-form anomaly score for each newly arrived traffic matrix, without revisiting historical data or costly iterative computation. We further provide a theoretical bound on the gap between anomaly scores derived from $\mathcal{C}$ and those from the full tensor $\mathcal{M}$. Extensive experiments on  real-world network traffic datasets against a total of twelve baselines show that CTensor achieves competitive approximation quality and enables CTensor-AD to detect anomalies at a fast speed within 10–38ms per data item while retaining traffic data spanning only 20 to 30 time slots,  confirming its suitability for real-time streaming network monitoring under constrained storage and computational resources.

## Requirements
1. MATLAB R2024b (or later)
2. Tensor-Tensor Product Toolbox (t-SVD): https://github.com/canyilu/tproduct

## Datasets

| Dataset | Nodes | OD Pairs | Time Slots | Duration |
|---------|-------|----------|------------|----------|
| Abilene | 12 | 144 | 48,384 | 6 months |
| Géant   | 23 | 529 | 10,772 | 4 months |

## Quick Start

Run the main script for each dataset:

- **Abilene dataset**:
  ```matlab
  run('mainAbilene.m')
  ```

- **Géant dataset**:
  ```matlab
  run('mainGeant.m')
  ```


## License

This project is licensed under the MIT License.
