# Unit-input tracer (cmuxterm-hq#7896): logs every path a Python process opens, lists or scans, and every command it runs.
import os, sys
_out = os.environ.get("UNIT_TRACE_DIR")
if _out:
    _f = open(os.path.join(_out, f"{os.getpid()}.log"), "a", buffering=1)
    _w = _f.write
    def _hook(event, args):
        try:
            if event == "open" and args and isinstance(args[0], (str, bytes, os.PathLike)):
                _w(f"open\t{os.fsdecode(os.fspath(args[0]))}\n")
            elif event in ("os.listdir", "os.scandir") and args:
                p = args[0]
                if p is None: p = "."
                if isinstance(p, (str, bytes, os.PathLike)):
                    _w(f"list\t{os.path.abspath(os.fsdecode(os.fspath(p)))}\n")
            elif event in ("glob.glob", "glob.glob/2"):
                _w(f"glob\t{args[0]}\n")
            elif event == "subprocess.Popen":
                _w(f"exec\t{args[1]!r}\t{os.getcwd()}\n")
            elif event == "os.stat" and False:
                pass
        except Exception:
            pass
    sys.addaudithook(_hook)
