class InputColor extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
    this.colorValue = '#000000';
  }

  static get observedAttributes() {
    return ['value'];
  }

  connectedCallback() {
    this.colorValue = this.getAttribute('value') || '#000000';
    this.render();
    this.setupEventListeners();
  }

  attributeChangedCallback(name, oldValue, newValue) {
    if (name === 'value' && newValue) {
      this.colorValue = newValue;
      this.updateInputs();
    }
  }

  render() {
    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .color-input-container {
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 16px;
          border: 2px solid #e1e5e9;
          border-radius: 8px;
          background: white;
          transition: border-color 0.2s ease;
        }
        
        .color-input-container:focus-within {
          border-color: #007bff;
        }
        
        .color-picker {
          width: 60px;
          height: 40px;
          border: 2px solid #e1e5e9;
          border-radius: 6px;
          cursor: pointer;
          background: none;
          padding: 0;
          outline: none;
        }
        
        .color-picker::-webkit-color-swatch-wrapper {
          padding: 0;
        }
        
        .color-picker::-webkit-color-swatch {
          border: none;
          border-radius: 4px;
        }
        
        .hex-input {
          flex: 1;
          padding: 10px 12px;
          border: 2px solid #e1e5e9;
          border-radius: 6px;
          font-size: 16px;
          font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
          outline: none;
          transition: border-color 0.2s ease;
        }
        
        .hex-input:focus {
          border-color: #007bff;
        }
        
        .hex-input.invalid {
          border-color: #dc3545;
          background-color: #fff5f5;
        }
        
        .color-preview {
          width: 40px;
          height: 40px;
          border: 2px solid #e1e5e9;
          border-radius: 6px;
          background-color: ${this.colorValue};
          transition: background-color 0.2s ease;
        }
        
        .label {
          font-size: 14px;
          font-weight: 500;
          color: #333;
          margin-bottom: 8px;
          display: block;
        }
        
        .error-message {
          color: #dc3545;
          font-size: 12px;
          margin-top: 4px;
          display: none;
        }
        
        .error-message.show {
          display: block;
        }
      </style>
      
      <div class="color-input-container">
        <input 
          type="color" 
          class="color-picker" 
          value="${this.colorValue}"
        />
        <input 
          type="text" 
          class="hex-input" 
          value="${this.colorValue}"
          placeholder="#000000"
          maxlength="7"
        />
        <div class="color-preview"></div>
      </div>
    `;
  }

  setupEventListeners() {
    const colorPicker = this.shadowRoot.querySelector('.color-picker');
    const hexInput = this.shadowRoot.querySelector('.hex-input');
    const colorPreview = this.shadowRoot.querySelector('.color-preview');

    colorPicker.addEventListener('input', (e) => {
      this.updateFromColorPicker(e.target.value);
    });

    hexInput.addEventListener('input', (e) => {
      this.updateFromHexInput(e.target.value);
    });

    hexInput.addEventListener('blur', (e) => {
      this.validateAndFormatHex(e.target.value);
    });

    hexInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        this.validateAndFormatHex(e.target.value);
      }
    });
  }

  updateFromColorPicker(color) {
    this.colorValue = color;
    this.updateInputs();
    this.dispatchChangeEvent();
  }

  updateFromHexInput(hex) {
    const cleanHex = hex.replace(/[^0-9A-Fa-f#]/g, '');
    
    if (this.isValidHex(cleanHex)) {
      this.colorValue = cleanHex.startsWith('#') ? cleanHex : `#${cleanHex}`;
      this.updateInputs();
      this.dispatchChangeEvent();
    }
  }

  validateAndFormatHex(hex) {
    const hexInput = this.shadowRoot.querySelector('.hex-input');
    const errorMessage = this.shadowRoot.querySelector('.error-message');
    
    if (!hex) {
      this.colorValue = '#000000';
      this.updateInputs();
      this.dispatchChangeEvent();
      return;
    }

    let cleanHex = hex.replace(/[^0-9A-Fa-f#]/g, '');
    
    if (!cleanHex.startsWith('#')) {
      cleanHex = `#${cleanHex}`;
    }

    if (this.isValidHex(cleanHex)) {
      this.colorValue = cleanHex;
      this.updateInputs();
      this.dispatchChangeEvent();
      hexInput.classList.remove('invalid');
      if (errorMessage) errorMessage.classList.remove('show');
    } else {
      hexInput.classList.add('invalid');
      if (errorMessage) errorMessage.classList.add('show');
    }
  }

  isValidHex(hex) {
    return /^#[0-9A-Fa-f]{6}$/.test(hex);
  }

  updateInputs() {
    const colorPicker = this.shadowRoot.querySelector('.color-picker');
    const hexInput = this.shadowRoot.querySelector('.hex-input');
    const colorPreview = this.shadowRoot.querySelector('.color-preview');

    if (colorPicker) colorPicker.value = this.colorValue;
    if (hexInput) hexInput.value = this.colorValue;
    if (colorPreview) colorPreview.style.backgroundColor = this.colorValue;
  }

  dispatchChangeEvent() {
    this.dispatchEvent(new CustomEvent('change', {
      detail: { value: this.colorValue },
      bubbles: true
    }));
  }

  // Public methods
  getValue() {
    return this.colorValue;
  }

  setValue(value) {
    if (this.isValidHex(value)) {
      this.colorValue = value;
      this.updateInputs();
    }
  }

  // Getters and setters for standard HTML attributes
  get value() {
    return this.getValue();
  }

  set value(val) {
    this.setValue(val);
  }
}

customElements.define('input-color', InputColor);

