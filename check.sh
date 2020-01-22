check-gpu()
{
  echo "========== Check Nvidia Gpu =========="
  if type nvidia-smi &>/dev/null; then
    echo "GPU Detected!!"
    gpu_detected=true
  else
    echo "No Detected"
    gpu_detected=false
  fi
}
