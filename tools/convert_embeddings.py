from pathlib import Path
import numpy as np

M = Path(__file__).resolve().parents[1] / "assets" / "model"
E = np.load(M / "embeddings.npy").astype("<f4")      # little-endian float32
print("gallery shape:", E.shape)                      # (n_images, 1280) expected
E.tofile(M / "embeddings.bin")
print("wrote embeddings.bin,", E.nbytes, "bytes")