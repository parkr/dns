## dns

Parker's DNS entries.

### Making changes

Modify the YAML file for the zone you'd like to update. The top-level key
is the subdomain value, and its value is a Hash/Dictionary of values.

A record:

```yaml
www:
  type: CNAME
  value: parkr.github.io.
```

This will create a CNAME record at `www.<your-zone>` which points to
`parkr.github.io`. Easy, huh?

### Testing

Before applying your change, test it:

```bash
$ script/cibuild || script/apply
```

It should print that there were mismatches and what it would do.

### Applying your change

Once you're satisfied with your change, run:

```bash
$ script/apply --doit
```

If it complains about too many changes, be VERY CAREFUL! You can _force_
changes by adding the `--force` flag to your `script/apply` call.
