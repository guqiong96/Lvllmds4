# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project

import ast
from pathlib import Path


def test_sparse_attention_compressor_does_not_require_cute_arch_fmin():
    source_path = (
        Path(__file__).parents[2]
        / "vllm"
        / "models"
        / "deepseek_v4"
        / "nvidia"
        / "ops"
        / "sparse_attn_compress_cutedsl.py"
    )
    tree = ast.parse(source_path.read_text())

    assert not any(
        isinstance(node, ast.Attribute) and node.attr == "fmin"
        for node in ast.walk(tree)
    )
