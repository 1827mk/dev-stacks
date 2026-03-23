# Code Generator Skill

Generate code from templates with configurable depth levels.

## Process

1. **Parse arguments**
   - Extract `<what>` and `--level` from $ARGUMENTS
   - Default level: scaffold

2. **Load DNA**
   - Read `.dev-stacks/dna.json`
   - Detect project type, languages, frameworks
   - Select appropriate templates

3. **Select template based on `<what>`**
   - api-endpoint → REST/GraphQL handler
   - react-component → Functional component with hooks
   - service-class → Business logic class
   - test-file → Unit test structure
   - crud → Full CRUD operations

4. **Generate by level**
   - scaffold: Structure + signatures only
   - logic: + implementation
   - full: + tests

5. **Write files**
   - Use Write tool to create files
   - Follow project conventions from DNA

## Templates (embedded)

### api-endpoint (Node.js/Express)
```javascript
// scaffold
router.<METHOD>('/<path>', async (req, res) => {
  // TODO: implement
});

// logic
router.<METHOD>('/<path>', async (req, res) => {
  try {
    const { <params> } = req.body;
    const result = await <Service>.<method>(<params>);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// full (+ test)
describe('<name> endpoint', () => {
  it('should <behavior>', async () => {
    // arrange
    // act
    // assert
  });
});
```

### react-component
```typescript
// scaffold
export function <Name>() {
  return <div>TODO</div>;
}

// logic
export function <Name>({ prop }: Props) {
  const [state, setState] = useState(initial);
  useEffect(() => {}, []);
  return <div>{state}</div>;
}

// full (+ test)
import { render, screen } from '@testing-library/react';
describe('<Name>', () => {
  it('renders', () => render(<Name />));
});
```

### service-class (TypeScript)
```typescript
// scaffold
export class <Name>Service {
  async <method>(): Promise<Result> {
    throw new Error('Not implemented');
  }
}

// logic
export class <Name>Service {
  constructor(private repo: Repository) {}
  async <method>(input: Input): Promise<Result> {
    const data = await this.repo.find();
    return this.transform(data);
  }
}
```

## Output

After generation:
```
GENERATED: <what>
Level: <level>
Files: <list>
Next: /dev-stacks:check to verify
```
