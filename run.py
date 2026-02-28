import sys
from pathlib import Path

project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from autoclicker.main import main

if __name__ == "__main__":
    main()
