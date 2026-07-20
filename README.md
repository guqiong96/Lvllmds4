# Lvllmds4

A fork of [jasl/vllm](https://github.com/jasl/vllm) (branch: `codex/ds4-sm120-min-enable`) with CPU-GPU hybrid inference support for DeepSeek-V4 on SM120+.

## Origin

This project integrates the CPU-GPU hybrid inference engine **[lk_moe](https://pypi.org/project/lk-moe/)** into a specialized vLLM fork:

- **Base vLLM Fork:** Forked from `jasl/vllm` (branch `codex/ds4-sm120-min-enable`), which provides the compatibility modifications needed for DeepSeek-V4 on SM120 architecture.
- **Hybrid Inference:** The lk_moe engine enables MOE layers to leverage both GPU VRAM and CPU system memory for collaborative computation, with NUMA-aware scheduling and expert weight management.

This version is purpose-built to run **DeepSeek V4 on hardware with SM120+ compute capability**.

## Relationship with LvLLM

Lvllmds4 is part of the LvLLM ecosystem—a family of parallel projects that integrate the lk_moe hybrid inference engine into different vLLM branches for different model/hardware targets:

| Project | Upstream vLLM Branch | Target |
|---------|---------------------|--------|
| [LvLLM](https://github.com/guqiong96/Lvllm) | Latest vLLM mainline | General MoE models (Qwen3, GLM, MiniMax, Kimi, etc.) |
| Lvllmds4 (this repo) | `jasl/vllm` (`codex/ds4-sm120-min-enable`) | DeepSeek-V4 (SM120+) |
| [Lvllmds4-x](https://github.com/guqiong96/Lvllmds4-x) | `yhfgyyf/vllm-deepseek-v4-sm89` | DeepSeek-V4 (SM80+) |

Similarly, **[Lsglang](https://github.com/guqiong96/Lsglang)** integrates lk_moe into sglang for the same hybrid inference capabilities across frameworks.

## Usage Guide

Pre-built releases and detailed installation/usage instructions for DeepSeek-V4 on SM120+ are available on the **[Releases page](https://github.com/guqiong96/Lvllmds4/releases)**.